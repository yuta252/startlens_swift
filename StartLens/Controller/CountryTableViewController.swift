//
//  CountryTableViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/29.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {

    var apiKey = String()
    var country = String()
    var prevSelectedNum = Int()
    var countryObjList = [Country]()
    let countryArray: KeyValuePairs = [
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        country = UserDefaults.standard.string(forKey: "country") ?? "OT"
        
        // TabaleView
        tableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.bounces = false
        tableView.isScrollEnabled = true
        
        setupUI()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupUI(){
        let roopNum = countryArray.count - 1
        for i in 0...roopNum{
            let countryCode = countryArray[i].key
            let countryName = countryArray[i].value
            var isSelected = false

            if countryCode == country{
                isSelected = true
            }
            let countryObj:Country = Country(countryCode: countryCode, countryName: countryName, isSelected: isSelected)
            self.countryObjList.append(countryObj)
        }

    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let countryText = cell.languageText!
        countryText.text = countryObjList[indexPath.row].countryName
        let checkImage = cell.checkMark!
        checkImage.image = UIImage(systemName: "checkmark")
        
        if countryObjList[indexPath.row].isSelected{
            checkImage.tintColor = ThemeColor.main
            // cellの初期状態をselectにする
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            // 管理用のselect
            prevSelectedNum = indexPath.row
            print("selected: \(countryObjList[indexPath.row])")
        }else{
            checkImage.tintColor = .lightGray
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // select
        countryObjList[indexPath.row].isSelected = true
        print("selected: \(countryObjList[indexPath.row])")
        // deselect
        countryObjList[prevSelectedNum].isSelected = false
        print("deselected: \(countryObjList[prevSelectedNum])")
        // 更新
        prevSelectedNum = indexPath.row
        // Userdefaultの変更
        country = countryObjList[indexPath.row].countryCode
        UserDefaults.standard.set(country, forKey: "country")
        tableView.reloadData()
        print("table is reloaded")
        // TODO:サーバーに情報を送る
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}

