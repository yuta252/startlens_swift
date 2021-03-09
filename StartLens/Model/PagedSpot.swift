//
//  PagedSpot.swift
//  StartLens
//
//  Created by 中野　裕太 on 2021/03/08.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import Foundation

struct Params: Codable {
    var page: Int
    var prefecture: String
    var category: String
    var last: Int
    var count: String
    var query: String
}

struct Meta: Codable {
    var params: Params
}

struct PagedSpot: Codable {
    var meta: Meta
    var data: [Spot]
}
