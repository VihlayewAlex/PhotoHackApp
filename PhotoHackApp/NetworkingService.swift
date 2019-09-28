//
//  NetworkingService.swift
//  SkeletonKey
//
//  Created by Alex on 9/9/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

enum CustomError: LocalizedError {
    case runtime(String)
    case undefined
    
    var errorDescription: String? {
        switch self {
        case .runtime(let value):
            return value
        case .undefined:
            return "Undefined error"
        }
    }
}

enum HTTPMethod: String {
    case POST
    case GET
    case PATCH
    case DELETE
}

struct EndpointCollection { }

struct Endpoint {
    var method: HTTPMethod
    var pathEnding: String
}

extension Endpoint {
    
    var url: URL {
        let pathString = Config.basePath /*+ Config.apiVersion*/ + pathEnding
        return URL(string: pathString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
    }
    
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

class NetworkingService {
    
    private let urlSession = URLSession.shared
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func performRequest<D: Encodable, R: Decodable>(to endpoint: Endpoint, with jsonData: D, completion: @escaping (Result<R>) -> Void) {
        var data: Data
        do {
            data = try encoder.encode(jsonData)
        } catch {
            completion(.failure(error))
            return
        }
        request(to: endpoint, with: data) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let response = try strongSelf.decoder.decode(Response<R>.self, from: data)
                    if let errors = response.errors {
                        completion(.failure(CustomError.runtime(errors.joined(separator: ", "))))
                    } else {
                        completion(.success(response.data!))
                        return
                    }
                } catch {
                    print("Data: ", String(data: data, encoding: .utf8) ?? "nil")
                    completion(.failure(error))
                    return
                }
            } else {
                completion(.failure(CustomError.undefined))
                return
            }
        }
    }
    
    func performRequest<D: Encodable>(to endpoint: Endpoint, with jsonData: D, completion: @escaping (Error?) -> Void) {
        var data: Data
        do {
            data = try encoder.encode(jsonData)
        } catch {
            completion(error)
            return
        }
        request(to: endpoint, with: data) { (_, _, error) in
            completion(error)
            return
        }
    }
    
    func performRequest<R: Decodable>(to endpoint: Endpoint, completion:  @escaping (Result<R>) -> Void) {
        request(to: endpoint, with: nil) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let response = try strongSelf.decoder.decode(Response<R>.self, from: data)
                    if let errors = response.errors {
                        completion(.failure(CustomError.runtime(errors.joined(separator: ", "))))
                    } else {
                        completion(.success(response.data!))
                        return
                    }
                } catch {
                    print("Data: ", String(data: data, encoding: .utf8) ?? "nil")
                    completion(.failure(error))
                    return
                }
            } else {
                completion(.failure(CustomError.undefined))
                return
            }
        }
    }
    
    private func request(to endpoint: Endpoint, with data: Data?, responseHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: endpoint.url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = data
        urlSession.dataTask(with: request, completionHandler: responseHandler).resume()
    }
    
}
