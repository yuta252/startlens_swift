//
//  Country.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/29.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Country {
    let countryCode: String
    let countryName: String
    var isSelected: Bool
    
    func setCountryToDevise() {
        UserDefaults.standard.set(self.countryCode, forKey: "country")
        print("Action: setCountryToDevise, Message: country is set to UserDefaults")
    }
    
    static func updateCountry(touristId: String, token: String, country: String) {
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": token]
        let url = Constants.baseURL + Constants.touristsURL + "/" + touristId
        let parameters = ["tourist":["country": country]]
        
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let json: JSON = JSON(response.data as Any)
                print("Action: updateCountry, json: \(json)")

                if json["id"].int == nil {
                    // Failed to update country
                    print("Action: updateCountry, Message: Failed to update country")
                } else {
                    // Successfully update country
                    print("Action: updateCountry, Message: Successed to update country")
                }
            case .failure(let error):
                print("Action: updateCountry, Message: Error occured. \(error)")
            }
        }
    }
}
