//
//  LanguageTableViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/28.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class LanguageTableViewController: UITableViewController {

    
    var token = String()
    var language = String()
    var touristId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial settigns
        language = Language.getLanguage()
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else{
            // if cannot get a token, move to login screen
            print("Action: ViewDidLoad, Message: No token Error")
            return
        }
        token = savedToken
        
        guard let savedId = UserDefaults.standard.string(forKey: "id") else {
            print("Action: ViewDidLoad, Message: No touristId Error")
            return
        }
        touristId = savedId
        
        setupTableView()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.bounces = false
        tableView.isScrollEnabled = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.languageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.languageText.text = Constants.languageArray[indexPath.row].value
        
        let checkImage = cell.checkMark!
        let currentLanguageNum = Constants.languageArray.firstIndex(where: { $0.0 == language})
        checkImage.image = UIImage(systemName: "checkmark")
        if indexPath.row == currentLanguageNum{
            checkImage.tintColor = ThemeColor.main
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }else{
            checkImage.tintColor = .lightGray
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Action: didSelectRowAt, Message: function is called")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let cell = tableView.cellForRow(at: indexPath) as! LanguageCell
        let checkImage = cell.checkMark!
        checkImage.tintColor = ThemeColor.main
        // Set to UserDefaults
        language = Constants.languageArray[indexPath.row].key
        Language.setLanguageToDevise(language: language)
        // Reset UI View
        resetViews()
        // Sent to API server
        Language.updateLanguage(touristId: self.touristId, token: self.token, language: self.language)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Action: didDeselectRowAt, Message: function is called")
        let cell = tableView.cellForRow(at: indexPath) as! LanguageCell
        cell.checkMark.tintColor = .lightGray
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    // Reset all UI view to change language
    func resetViews() {
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "homeTabBar")
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController = tabBarController
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.makeKeyAndVisible()
    }
}
