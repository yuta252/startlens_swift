//
//  CountryTableViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/29.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {

    var token = String()
    var country = String()
    var touristId = String()
    var prevSelectedNum = Int()
    var countryObjList = [Country]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial Settings
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

        country = UserDefaults.standard.string(forKey: "country") ?? "OT"
        
        setupUI()
        setupTableView()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupUI() {
        let roopNum = Constants.countryArray.count - 1
        for i in 0...roopNum {
            let countryCode = Constants.countryArray[i].key
            let countryName = Constants.countryArray[i].value
            var isSelected = false

            if countryCode == self.country{
                isSelected = true
            }
            let countryObj:Country = Country(countryCode: countryCode, countryName: countryName, isSelected: isSelected)
            self.countryObjList.append(countryObj)
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.bounces = false
        tableView.isScrollEnabled = true
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.countryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let countryText = cell.languageText!
        countryText.text = countryObjList[indexPath.row].countryName
        let checkImage = cell.checkMark!
        checkImage.image = UIImage(systemName: "checkmark")
        
        if countryObjList[indexPath.row].isSelected {
            checkImage.tintColor = ThemeColor.main
            // Initial setting for selected language
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            // Save selected Cell
            prevSelectedNum = indexPath.row
            print("Action: cellForRowAt, selected cell: \(countryObjList[indexPath.row])")
        } else {
            checkImage.tintColor = .lightGray
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countryObjList[indexPath.row].isSelected = true
        print("Action: didSelectRowAt, selected cell: \(countryObjList[indexPath.row])")
        countryObjList[prevSelectedNum].isSelected = false
        print("Action: didSelectRowAt, deselected cell: \(countryObjList[prevSelectedNum])")
        prevSelectedNum = indexPath.row

        countryObjList[indexPath.row].setCountryToDevise()
        self.country = countryObjList[indexPath.row].countryCode
        
        tableView.reloadData()
        // Send API server
        Country.updateCountry(touristId: self.touristId, token: self.token, country: self.country)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

