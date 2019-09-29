//
//  Photo.swift
//  PhotoHackApp
//
//  Created by Alex on 9/29/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct PhotoRequest: Encodable {
    let emotion: Int
    let photo: String//[UInt8]
}

struct PhotoResponse: Decodable {
    let links: [String]
}

extension EndpointCollection {
    
    static let photo = Endpoint(method: .POST, pathEnding: "ImageTemplate/photo")
    
}
