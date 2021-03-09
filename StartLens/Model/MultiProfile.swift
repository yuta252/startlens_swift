//
//  MultiProfile.swift
//  StartLens
//
//  Created by 中野　裕太 on 2021/03/08.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import Foundation

struct MultiProfile: Codable {
    var id: Int
    var userId: Int
    var lang: String
    var username: String
    var selfIntro: String
    var addressPrefecture: String
    var addressCity: String
    var addressStreet: String
    var entranceFee: String
    var businessHours: String
    var holiday: String
}
