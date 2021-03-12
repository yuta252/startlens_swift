//
//  Exhibit.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/11.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import Foundation

struct Exhibit: Codable {
    var id: Int
    var pictures: [Picture]
    var multiExhibits: [MultiExhibit]
}
