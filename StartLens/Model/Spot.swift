//
//  Spot.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/17.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

struct Spot: Codable {
    var id: Int
    var isFavorite: Bool
    var profile: Profile
    var multiProfiles: [MultiProfile]
    var reviews: [Review]
    
    func selectMultiProfileByLang(lang: String) -> MultiProfile {
        // 1st priority
        var multiProfile = self.multiProfiles.filter{ (multiProfile) in
            return multiProfile.lang == lang
        }
        if (!multiProfile.isEmpty) { return multiProfile[0] }
        // default language
        multiProfile = self.multiProfiles.filter{ (multiProfile) in
            return multiProfile.lang == "en"
        }
        if (!multiProfile.isEmpty) { return multiProfile[0] }
        // japanese
        multiProfile = self.multiProfiles.filter{ (multiProfile) in
            return multiProfile.lang == "ja"
        }
        if (!multiProfile.isEmpty) { return multiProfile[0] }
        return multiProfiles[0]
    }
    
    mutating func addFavorite(token: String, spotId: Int) {
        /**
         - Parameters:
            - token: JWT token to communicate with API server
            - spotId: spot ID  that favorite have to be added
         */
        self.isFavorite = true
        let headers: HTTPHeaders = ["Authorization": token, "Content-Type": "application/json"]
        let url = Constants.baseURL + Constants.favoriteURL
        let params = ["favorite": ["userId": spotId]]
        print("url: \(url)")
        print("Ation: addFavorite, Message: Start to send favorite")
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("json: \(json)")
                if json["id"].int != nil {
                    print("Ation: addFavorite, Message: Complete to add favorite")
                }
            case .failure(let error):
                print(error)
            }
            print("Ation: addFavorite, Message: Finish to send favorite")
        }
    }
    
    mutating func removeFavorite(token: String, spotId: Int) {
        /**
         - Parameters:
            - token: JWT token to communicate with API server
            - spotId: spot ID  that favorite have to be removed
         */
        self.isFavorite = false
        let headers: HTTPHeaders = ["Authorization": token, "Content-Type": "application/json"]
        let url = Constants.baseURL + Constants.favoriteURL + "/" + String(spotId)
        print("url: \(url)")
        print("Ation: removeFavorite, Message: Start to send removing favorite")
        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("json: \(json)")
                print("Ation: addFavorite, Message: Complete to remove favorite")
            case .failure(let error):
                print(error)
            }
            print("Ation: addFavorite, Message: Finish to send removing favorite")
        }
    }
}
