//
//  Constants.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/09.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

enum Environment: String {
    case development = "development"
    case test = "test"
    case production = "production"
}

struct Constants {
    // To be changed by environment
    static let environment = Environment.test
      
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
    
    static let languageArray: KeyValuePairs = [
        "en": "languageEN".localized,
        "ja": "languageJA".localized
    ]
    
    static let countryArray: KeyValuePairs = [
        "AF": "countryAF".localized, "DZ": "countryDZ".localized, "AR": "countryAR".localized, "AM": "countryAM".localized,
        "AU": "countryAU".localized, "AT": "countryAT".localized, "AZ": "countryAZ".localized, "BH": "countryBH".localized,
        "BD": "countryBD".localized, "BY": "countryBY".localized, "BE": "countryBE".localized, "BO": "countryBO".localized,
        "BA": "countryBA".localized, "BR": "countryBR".localized, "BG": "countryBG".localized, "KH": "countryKH".localized,
        "CM": "countryCM".localized, "CA": "countryCA".localized, "CF": "countryCF".localized, "TD": "countryTD".localized,
        "CL": "countryCL".localized, "CN": "countryCN".localized, "CO": "countryCO".localized, "CG": "countryCG".localized,
        "CR": "countryCR".localized, "CI": "countryCI".localized, "HR": "countryHR".localized, "CU": "countryCU".localized,
        "CZ": "countryCZ".localized, "DK": "countryDK".localized, "DO": "countryDO".localized, "EC": "countryEC".localized,
        "EG": "countryEG".localized, "ET": "countryET".localized, "FI": "countryFI".localized, "FR": "countryFR".localized,
        "GE": "countryGE".localized, "DE": "countryDE".localized, "GH": "countryGH".localized, "GR": "countryGR".localized,
        "GL": "countryGL".localized, "GT": "countryGT".localized, "GN": "countryGN".localized, "HN": "countryHN".localized,
        "HK": "countryHK".localized, "HU": "countryHU".localized, "IS": "countryIS".localized, "IN": "countryIN".localized,
        "ID": "countryID".localized, "IR": "countryIR".localized, "IQ": "countryIQ".localized, "IE": "countryIE".localized,
        "IL": "countryIL".localized, "IT": "countryIT".localized, "JM": "countryJM".localized, "JP": "countryJP".localized,
        "JO": "countryJO".localized, "KZ": "countryKZ".localized, "KE": "countryKE".localized, "KP": "countryKP".localized,
        "KR": "countryKR".localized, "KW": "countryKW".localized, "LA": "countryLA".localized, "LV": "countryLV".localized,
        "LB": "countryLB".localized, "LR": "countryLR".localized, "LY": "countryLY".localized, "LI": "countryLI".localized,
        "LT": "countryLT".localized, "LU": "countryLU".localized, "MY": "countryMY".localized, "ML": "countryML".localized,
        "MX": "countryMX".localized, "MN": "countryMN".localized, "ME": "countryME".localized, "MA": "countryMA".localized,
        "MM": "countryMM".localized, "NA": "countryNA".localized, "NP": "countryNP".localized, "NL": "countryNL".localized,
        "NZ": "countryNZ".localized, "NG": "countryNG".localized, "NO": "countryNO".localized, "PK": "countryPK".localized,
        "PA": "countryPA".localized, "PY": "countryPY".localized, "PE": "countryPE".localized, "PH": "countryPH".localized,
        "PL": "countryPL".localized, "PT": "countryPT".localized, "QA": "countryQA".localized, "RO": "countryRO".localized,
        "RU": "countryRU".localized, "RW": "countryRW".localized, "SA": "countrySA".localized, "SN": "countrySN".localized,
        "RS": "countryRS".localized, "SG": "countrySG".localized, "SK": "countrySK".localized, "SI": "countrySI".localized,
        "ZA": "countryZA".localized, "SS": "countrySS".localized, "ES": "countryES".localized, "LK": "countryLK".localized,
        "SD": "countrySD".localized, "SE": "countrySE".localized, "CH": "countryCH".localized, "TW": "countryTW".localized,
        "TJ": "countryTJ".localized, "TZ": "countryTZ".localized, "TH": "countryTH".localized, "TN": "countryTN".localized,
        "TR": "countryTR".localized, "UG": "countryUG".localized, "UA": "countryUA".localized, "AE": "countryAE".localized,
        "GB": "countryGB".localized, "US": "countryUS".localized, "UY": "countryUY".localized, "UZ": "countryUZ".localized,
        "VE": "countryVE".localized, "VN": "countryVN".localized, "YE": "countryYE".localized, "ZM": "countryZM".localized,
        "ZW": "countryZW".localized, "OT": "countryOT".localized
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
    static let touristLoadURL = "tourist/load"
    static let touristsURL = "tourist/tourists"
    static let tokenURL = "tourist/token"
    static let spotURL = "tourist/spots"
    static let favoriteURL = "tourist/favorites"
    static let exhibitURL = "tourist/spots"
    static let reviewURL = "tourist/reviews"
    static let inferenceURL = "inference/knn"
    
    // passwrodRestURL
    static let passResetURL = "http://startlens.local/api2/passreset/"
    static let passAuthURL = "http://startlens.local/api2/passauth/"
    static let passSendURL = "http://startlens.local/api2/passsend/"
    // Contact
    static let contactURL = "http://startlens.local/api2/contact/"
}
