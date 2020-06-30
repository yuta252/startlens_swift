//
//  StringExtension.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/24.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import Foundation

extension String{
    var localized: String{
        let lang = UserDefaults.standard.string(forKey: "language")!
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
