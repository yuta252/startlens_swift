//
//  LoginSelectViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/09.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class LoginSelectViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var agreementLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // 言語国設定の保存
        setupLocale()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        performSegue(withIdentifier: "logIn", sender: nil)
    }
    
    func setupUI(){
        signUpButton.setTitle("signUpButtonText".localized, for: .normal)
        logInButton.setTitle("logInButtonText".localized, for: .normal)
        let AttributedPrivacyString = NSAttributedString(string: "privacyPolicyButtonText".localized, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.white])
        privacyPolicyButton.setAttributedTitle(AttributedPrivacyString, for: .normal)
        let AttributedTermsString = NSAttributedString(string: "termsButtonText".localized, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.white])
        termsButton.setAttributedTitle(AttributedTermsString, for: .normal)
        agreementLabel.text = "agreementText".localized
    }
    
    
    func setupLocale(){
        let locale = NSLocale.current
        let localeId = locale.identifier
        let arr: [String] = localeId.components(separatedBy: "_")
        
        UserDefaults.standard.set(arr[0], forKey: "language")
        UserDefaults.standard.set(arr[1], forKey: "country")
    }
}
