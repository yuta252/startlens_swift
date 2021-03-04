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
    @IBOutlet weak var contactTitle: UILabel!
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
        contactTitle.text = "settingContactTitle".localized
        privacyPolicyTitle.text = "privacyPolicyButtonText".localized
        termsTitle.text = "termsButtonText".localized
        versionTitle.text = "settingVersionTitle".localized
        versionNumber.text = "settingVersionNumber".localized
        logoutTitle.text = "settingLogoutTitle".localized
    }

    // MARK: - Table view data source

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
            return 5
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
    
    // headerが表示される時の処理
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = ThemeColor.firstString
        header.contentView.backgroundColor = ThemeColor.secondString
        
        if (section == 0){
            header.textLabel!.text = "settingHeaderTitle".localized
        }else if (section == 1){
            header.textLabel!.text = "appSettingHeaderTitle".localized
        }
    }
    
    // Footerが表示される時の処理
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.contentView.backgroundColor = ThemeColor.secondString
    }
    
    // タップ時の処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect: \(indexPath.section), \(indexPath.row)")
        
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                // 言語
                performSegue(withIdentifier: "language", sender: nil)
                break
            case 1:
                // 地域
                performSegue(withIdentifier: "country", sender: nil)
                break
            default:
                break
            }
        case 1:
            switch indexPath.row{
            case 0:
                // コンタクト
                performSegue(withIdentifier: "contact", sender: nil)
                break
            case 1:
                // プライバシーポリシー
                performSegue(withIdentifier: "privacyPolicy", sender: nil)
                break
            case 2:
                // 利用規約
                performSegue(withIdentifier: "terms", sender: nil)
                break
            case 4:
                // ログアウト
                print("didSelect: \(indexPath.section), \(indexPath.row)")
                let alert: UIAlertController = UIAlertController(title: "settingLogoutTitle".localized, message: "logoutMessage".localized, preferredStyle: .alert)
                // OKボタンアクション
                let defaultAction: UIAlertAction = UIAlertAction(title: "okButtonText".localized, style: UIAlertAction.Style.default) { (action: UIAlertAction!) in
                    // ログアウト処理
                    UserDefaults.standard.set(false, forKey: "isLogIn")
                    let LoginSelectVC = self.storyboard!.instantiateViewController(withIdentifier: "loginSelect") as! LoginSelectViewController
                    UIApplication.shared.keyWindow?.rootViewController = LoginSelectVC
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    print("ok is tapped")
                }
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "cancelButton".localized, style: UIAlertAction.Style.cancel) { (action: UIAlertAction!) in
                    // キャンセル時の処理
                    print("cancel is tapped")
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
