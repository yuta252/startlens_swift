//
//  Constants.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/09.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

//struct Constants{
//
//    static let appName = "Start Lens"
//
//    // signupのURL
//    static let signUpURL = "http://0.0.0.0:80/api2/authmail/"
//    // signupauthのURL
//    static let signUpAuthURL = "http://0.0.0.0:80/api2/authsuccess/"
//    // アンケート送信URL
//    static let QuestionURL = "http://0.0.0.:80/api2/question/"
//    // logInURL
//    static let logInURL = "http://0.0.0.0:80/api2/login/"
//    // passwrodRestURL
//    static let passResetURL = "http://0.0.0.0:80/api2/passreset/"
//    static let passAuthURL = "http://0.0.0.0:80/api2/passauth/"
//    static let passSendURL = "http://0.0.0.0:80/api2/passsend/"
//    // Home
//    static let homeURL = "http://0.0.0.0:80/api2/spotlist/?key="
//    static let query = "&q="
//    // Search
//    static let searchURL = "http://0.0.0.0:80/api2/searchlist/?key="
//    static let category = "&cat="
//    static let address = "&city="
//    // Likeボタンタップ時のURL
//    static let likeURL = "http://0.0.0.0:80/api2/islike/?key="
//    static let spot = "&spot="
//    static let islike = "&islike="
//    // favoriteページ
//    static let favoriteURL = "http://0.0.0.0:80/api2/favorite/?key="
//    // spotDetail
//    static let spotDetailURL = "http://0.0.0.0:80/api2/spotdetail/?key="
//    static let postReviewURL = "http://0.0.0.0:80/api2/postreview/"
//    // review List
//    static let reviewListURL = "http://0.0.0.0:80/api2/reviewlist/?key="
//    // Exhibit List
//    static let exhibitListURL = "http://0.0.0.0:80/api2/exhibitlist/?key="
//    // Exhibit Detail
//    static let exhibitDetailURL = "http://0.0.0.0:80/api2/exhibitdetail/?key="
//    static let exhibitId = "&exhibitId="
//    // Camera
//    static let cameraURL = "http://0.0.0.0:80/api2/camera/"
//}

enum Environment: String {
    case development = "development"
    case test = "test"
    case production = "production"
}

struct Constants {
    // To be changed by environment
    static let environment = Environment.development
      
    static let appName = "Start Lens"
    static let yearList = ["1941", "1942", "1943", "1944", "1945", "1946", "1947", "1948", "1949", "1950",
                           "1951", "1952", "1953", "1954", "1955", "1956", "1957", "1958", "1959", "1960",
                           "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970",
                           "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980",
                           "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990",
                           "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000",
                           "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010",
                           "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"]
    static let majorCategoryMap = [
        0: "unselected".localized, 11: "mountains".localized, 12: "plateau".localized, 13: "lake".localized, 14: "river".localized, 15: "waterfall".localized,
        16: "coast".localized, 17: "rock".localized, 18: "animal".localized, 19: "plant".localized, 20: "naturalPhenomenon".localized,
        21: "historicSite".localized, 22: "religiousBuilding".localized, 23: "castle".localized, 24: "village".localized, 25: "localLandscape".localized,
        26: "park".localized, 27: "building".localized, 28: "annualEvent".localized, 29: "zoo".localized, 30: "museum".localized,
        31: "themePark".localized, 32: "hotSpring".localized, 33: "food".localized, 34: "event".localized
    ]
    
    static var baseURL: String {
        get {
            switch Self.environment {
            case Environment.development:
                return "http://0.0.0.0:80/api/v1/"
            case Environment.test:
                return "http://startlens.local/api/v1/"
            case Environment.production:
                return "http://api.startlens.jp/api/v1/"
            }
        }
    }
    static let touristsURL = "tourist/tourists"
    static let tokenURL = "tourist/token"
    static let spotURL = "tourist/spots"
    static let favoriteURL = "tourist/favorites"
    // signupのURL
    static let signUpURL = "http://startlens.local/api2/authmail/"
    // signupauthのURL
    static let signUpAuthURL = "http://startlens.local/api2/authsuccess/"
    
    // logInURL
    static let logInURL = "http://startlens.local/api2/login/"
    // passwrodRestURL
    static let passResetURL = "http://startlens.local/api2/passreset/"
    static let passAuthURL = "http://startlens.local/api2/passauth/"
    static let passSendURL = "http://startlens.local/api2/passsend/"
    // Home
    static let homeURL = "http://startlens.local/api2/spotlist/?key="
    static let query = "&q="
    static let lang = "&lang="
    // Search
    static let searchURL = "http://startlens.local/api2/searchlist/?key="
    static let category = "&cat="
    static let address = "&city="
    // Likeボタンタップ時のURL
    static let likeURL = "http://startlens.local/api2/islike/?key="
    static let spot = "&spot="
    static let islike = "&islike="
    
    // spotDetail
    static let spotDetailURL = "http://startlens.local/api2/spotdetail/?key="
    static let postReviewURL = "http://startlens.local/api2/postreview/"
    // review List
    static let reviewListURL = "http://startlens.local/api2/reviewlist/?key="
    // Exhibit List
    static let exhibitListURL = "http://startlens.local/api2/exhibitlist/?key="
    // Exhibit Detail
    static let exhibitDetailURL = "http://startlens.local/api2/exhibitdetail/?key="
    static let exhibitId = "&exhibitId="
    // Camera
    static let cameraURL = "http://startlens.local/api2/camera/"
    // Contact
    static let contactURL = "http://startlens.local/api2/contact/"
}
