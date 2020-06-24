//
//  AppDelegate.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/08.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // キーボードを入力欄をかぶらなくする
        IQKeyboardManager.shared.enable = true
        // タブバーの設定
        UITabBar.appearance().tintColor = ThemeColor.main
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = ThemeColor.secondString
        
        let isLogIn = UserDefaults.standard.bool(forKey: "isLogIn")
        // 自動ログイン設定
        if isLogIn{
            // 2回目以降の起動
//            print("move home")
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialVC = storyboard.instantiateViewController(withIdentifier: "home")
//            self.window?.rootViewController = initialVC
//            self.window?.makeKeyAndVisible()
        }else{
            print("move to tutorial")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

