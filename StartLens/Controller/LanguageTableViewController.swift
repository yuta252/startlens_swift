//
//  LanguageTableViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/28.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class LanguageTableViewController: UITableViewController {

    
    var apiKey = String()
    var language = String()
    let languageArray: KeyValuePairs = [
        "en": "languageEN".localized,
        "ja": "languageJA".localized
    ]
    
    let languageItem = [
        "languageEN".localized,
        "languageJA".localized
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        language = UserDefaults.standard.string(forKey: "language") ?? "en"
        
        // TabaleView
        tableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.bounces = false
        tableView.isScrollEnabled = false
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let languageText = cell.languageText!
        languageText.text = languageItem[indexPath.row]
        let checkImage = cell.checkMark!
        
        let currentLanguageNum = languageArray.firstIndex(where: { $0.0 == language})
        checkImage.image = UIImage(systemName: "checkmark")
        if indexPath.row == currentLanguageNum{
            checkImage.tintColor = ThemeColor.main
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            print("selected is called")
        }else{
            checkImage.tintColor = .lightGray
        }
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let cell = tableView.cellForRow(at: indexPath) as! LanguageCell
        let checkImage = cell.checkMark!
        checkImage.tintColor = ThemeColor.main
        // Userdefaultの変更
        print("lang: \(languageArray[indexPath.row].key)")
        language = languageArray[indexPath.row].key
        UserDefaults.standard.set(language, forKey: "language")
        // 更新の反映
        resetViews()
        //self.navigationController?.popViewController(animated: true)
        
        // サーバーに情報を送る
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselect")
        let cell = tableView.cellForRow(at: indexPath) as! LanguageCell
        
        let checkImage = cell.checkMark!
        checkImage.tintColor = .lightGray
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    // すべてのUIを更新する処理
    func resetViews(){
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "homeTabBar")
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
//        let windows = UIApplication.shared.windows as [UIWindow]
//        print("windows: \(windows)")
//        for window in windows{
//            print("window: \(window)")
//            let subviews = window.subviews as [UIView]
//            for v in subviews{
//                print("subview:\(v)")
//                v.removeFromSuperview()
//                window.addSubview(v)
//            }
//        }
    }
}
