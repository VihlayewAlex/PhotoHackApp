//
//  Response.swift
//  SkeletonKey
//
//  Created by Alex on 9/9/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let data: T?
    //    let result: Bool
    let errors: [String]?
}
