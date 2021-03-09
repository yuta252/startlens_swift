//
//  Language.swift
//  StartLens
//
//  Created by 中野　裕太 on 2021/03/08.
//  Copyright © 2021 Nakano Yuta. All rights reserved.
//

import Foundation

struct Language {
    var locale: [String]
    var language: String = "na"
    var country: String = "na"
    
    init() {
        self.locale = Locale.preferredLanguages
        self.language = self.setLanguage()
        self.country = self.setCountry()
    }
    
    func setLanguage() -> String {
        print("locale: \(self.locale)")
        let localeArray = self.locale[0].components(separatedBy: "-")
        var localeLanguage = "na"
        if (localeArray[0] == "zh") {
            localeLanguage = self.locale[0]
        } else {
            localeLanguage = localeArray[0]
        }
        print("Action: setLanguage, Message: \(localeLanguage) is set")
        return localeLanguage
    }
    
    func setCountry() -> String {
        var localeCountry = "na"
        let firstLocale = self.locale[0]
        // Check first preferred country at first, go on the next preferred country if not exists
        if firstLocale.contains("-") {
            localeCountry = self.locale[0].components(separatedBy: "-")[1]
        } else if self.locale.count >= 2 {
            let secondLocale = self.locale[1]
            if secondLocale.contains("-") {
                localeCountry = secondLocale.components(separatedBy: "-")[1]
            }
        }
        print("Action: setCountry, Message: \(localeCountry) is set")
        return localeCountry
    }
    
    func setLocale() {
        UserDefaults.standard.set(self.language, forKey: "language")
        UserDefaults.standard.set(self.country, forKey: "country")
    }
    
    static func getLanguage() -> String {
        if let lang = UserDefaults.standard.string(forKey: "language") {
            print("Action: getLanguage, Message: language is \(lang)")
            return lang
        }
        print("Action: getLanguage, Message: language is default en")
        return "en"
    }
    
    static func getCountry() -> String {
        if let country = UserDefaults.standard.string(forKey: "language") {
            print("Action: getCountry, Message: country is \(country)")
            return country
        }
        print("Action: getLanguage, Message: language is default na")
        return "na"
    }
}
