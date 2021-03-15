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
    
    func selectMultiExhibitByLang(lang: String) -> MultiExhibit {
        // 1st priority
        var multiExhibit = self.multiExhibits.filter { (multiExhibit) -> Bool in
            return multiExhibit.lang == lang
        }
        if (!multiExhibit.isEmpty) { return multiExhibit[0] }
        // default language
        multiExhibit = self.multiExhibits.filter({ (multiExhibit) -> Bool in
            return multiExhibit.lang == "en"
        })
        if (!multiExhibit.isEmpty) { return multiExhibit[0] }
        // japanese
        multiExhibit = self.multiExhibits.filter({ (multiExhibit) -> Bool in
            return multiExhibit.lang == "ja"
        })
        if (!multiExhibit.isEmpty) { return multiExhibit[0] }
        return multiExhibits[0]
    }
}
