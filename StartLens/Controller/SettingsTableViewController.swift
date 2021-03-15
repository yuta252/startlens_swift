//
//  SettingsTableViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/27.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var contryTitle: UILabel!
    @IBOutlet weak var privacyPolicyTitle: UILabel!
    @IBOutlet weak var termsTitle: UILabel!
    @IBOutlet weak var versionTitle: UILabel!
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var logoutTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        languageTitle.text = "settingLanguageTitle".localized
        contryTitle.text = "settingCountryTitle".localized
        privacyPolicyTitle.text = "privacyPolicyButtonText".localized
        termsTitle.text = "termsButtonText".localized
        versionTitle.text = "settingVersionTitle".localized
        versionNumber.text = "settingVersionNumber".localized
        logoutTitle.text = "settingLogoutTitle".localized
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case 0:
            return 2
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = ThemeColor.firstString
        header.contentView.backgroundColor = ThemeColor.secondString
        
        if (section == 0) {
            header.textLabel!.text = "settingHeaderTitle".localized
        }else if (section == 1) {
            header.textLabel!.text = "appSettingHeaderTitle".localized
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.contentView.backgroundColor = ThemeColor.secondString
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // Move to Language select
                performSegue(withIdentifier: "language", sender: nil)
                break
            case 1:
                // Move to Country select
                performSegue(withIdentifier: "country", sender: nil)
                break
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                // // Move to Privacy policy
                performSegue(withIdentifier: "privacyPolicy", sender: nil)
                break
            case 1:
                // Move to Use of terms
                performSegue(withIdentifier: "terms", sender: nil)
                break
            case 3:
                // Logout Action
                let alert: UIAlertController = UIAlertController(title: "settingLogoutTitle".localized, message: "logoutMessage".localized, preferredStyle: .alert)
                // Logout OK button
                let defaultAction: UIAlertAction = UIAlertAction(title: "okButtonText".localized, style: UIAlertAction.Style.default) { (action: UIAlertAction!) in
                    // Logout
                    UserDefaults.standard.set("", forKey: "token")
                    UserDefaults.standard.set(false, forKey: "isLogIn")
                    let initialNavigationController = self.storyboard!.instantiateViewController(withIdentifier: "initialNavigation") as! UINavigationController
                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController = initialNavigationController
                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.makeKeyAndVisible()
                    print("Action: didSelectRowAt, Message: logout ok")
                }
                // Logout Cancel button
                let cancelAction: UIAlertAction = UIAlertAction(title: "cancelButton".localized, style: UIAlertAction.Style.cancel) { (action: UIAlertAction!) in
                    // Cancel Action
                    print("Action: didSelectRowAt, Message: logout cancel")
                }
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
                break
            default:
                break
            }
        default:
            break
        }
    }
}
