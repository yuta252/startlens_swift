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
        let roopNum = self.countryArray.count - 1
        for i in 0...roopNum {
            let countryCode = self.countryArray[i].key
            let countryName = self.countryArray[i].value
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
        return self.countryArray.count
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

