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
        let locale = Language()
        locale.setLocale()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
        
        let isLogIn = UserDefaults.standard.bool(forKey: "isLogIn")
        // Auto login
        if isLogIn {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeView = storyboard.instantiateViewController(identifier: "home") as! HomeViewController
//            self.navigationController?.pushViewController(homeView, animated: true)
            let tabBarVC = self.storyboard?.instantiateViewController(identifier: "homeTabBar") as! TabBarController
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let signUpVC = storyboard?.instantiateViewController(identifier: "signUp") as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        let logInVC = storyboard?.instantiateViewController(identifier: "logIn") as! LogInViewController
        navigationController?.pushViewController(logInVC, animated: true)
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
}
