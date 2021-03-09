//
//  Profile.swift
//  StartLens
//
//  Created by 中野　裕太 on 2021/03/08.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var id: Int
    var majorCategory: Int
    var telephone: String
    var companySite: String
    var url: String
    var rating: Float
    var ratingCount: Int
    var latitude: String
    var longitude: String
}
