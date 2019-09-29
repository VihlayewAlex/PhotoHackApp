//
//  Emotion.swift
//  PhotoHackApp
//
//  Created by Alex on 9/29/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

enum Emotion: Int {
    case happy = 1
    case sad
    case angry
    case fear
    case excited
    case indifferent
}

struct EmotionResponse: Decodable {
    let emotion: Int
}

extension EndpointCollection {
    
    static func emotion(text: String) -> Endpoint {
        return Endpoint(method: .GET, pathEnding: "ImageTemplate/emotion?text=\(text)")
    }
    
}
