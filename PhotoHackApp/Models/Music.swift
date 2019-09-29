//
//  music.swift
//  PhotoHackApp
//
//  Created by Alex on 9/29/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

typealias MusicResponse = [MusicEntity]

struct MusicEntity: Decodable {
    let title: String
    let preview: String
    let artist: ArtistInfo
}

struct ArtistInfo: Decodable {
    let id: Int
    let name: String
    let picture: String
}

extension EndpointCollection {
    
    static func music(phrase: String, words: [String]) -> Endpoint {
        return Endpoint(method: .GET, pathEnding: "imagetemplate?phrase=\(phrase)&words=\(words.joined(separator: " "))")
    }
    
}
