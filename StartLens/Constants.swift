//
//  Constants.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/09.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

struct Constants{
    
    // テスト：true, 本番: false
    static let isTest:Bool = true
    
    static let appName = "Start Lens"
    
    // signupのURL
    static let signUpURL = "http://0.0.0.0:80/api2/authmail/"
    // signupauthのURL
    static let signUpAuthURL = "http://0.0.0.0:80/api2/authsuccess/"
    // アンケート送信URL
    static let QuestionURL = "http://0.0.0.:80/api2/question/"
    // logInURL
    static let logInURL = "http://0.0.0.0:80/api2/login/"
    // passwrodRestURL
    static let passResetURL = "http://0.0.0.0:80/api2/passreset/"
    static let passAuthURL = "http://0.0.0.0:80/api2/passauth/"
    static let passSendURL = "http://0.0.0.0:80/api2/passsend/"
    // Home
    static let homeURL = "http://0.0.0.0:80/api2/spotlist/?key="
    static let query = "&q="
    // Search
    static let searchURL = "http://0.0.0.0:80/api2/searchlist/?key="
    static let category = "&cat="
    static let address = "&city="
    // Likeボタンタップ時のURL
    static let likeURL = "http://0.0.0.0:80/api2/islike/?key="
    static let spot = "&spot="
    static let islike = "&islike="
    // favoriteページ
    static let favoriteURL = "http://0.0.0.0:80/api2/favorite/?key="
    // spotDetail
    static let spotDetailURL = "http://0.0.0.0:80/api2/spotdetail/?key="
    static let postReviewURL = "http://0.0.0.0:80/api2/postreview/"
    // review List
    static let reviewListURL = "http://0.0.0.0:80/api2/reviewlist/?key="
    // Exhibit List
    static let exhibitListURL = "http://0.0.0.0:80/api2/exhibitlist/?key="
    // Exhibit Detail
    static let exhibitDetailURL = "http://0.0.0.0:80/api2/exhibitdetail/?key="
    static let exhibitId = "&exhibitId="
}
