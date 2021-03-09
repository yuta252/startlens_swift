//
//  Review.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/10.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import Foundation

struct Review: Codable {
    var id: Int
    var userId: Int
    var touristId: Int
    var lang: String
    var postReview: String
    var rating: Int
    var tourist: Tourist
    var createdAt: String
}
