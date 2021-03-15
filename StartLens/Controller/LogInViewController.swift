//
//  LogInViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/15.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class LogInViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate  {

    @IBOutlet weak var signInTitle: UILabel!
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passWordField: HoshiTextField!
    @IBOutlet weak var passWordMessage: UILabel!
    @IBOutlet weak var signinButtonText: UIButton!
    
    var authEmail = String()
    var authPassWord = String()
    var token = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passWordField.delegate = self

        setupUI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        // Validation of email address
        guard let emailAddress = emailField.text, !emailAddress.isEmpty else{
            passWordMessage.text = "emailValidMessage".localized
            passWordMessage.textColor = ThemeColor.errorString
            return
        }
        
        // Validation of password
        guard let passWord = passWordField.text, !passWord.isEmpty else{
            passWordMessage.text = "passValidMessage".localized
            passWordMessage.textColor = ThemeColor.errorString
            return
        }
        
        authEmail = emailAddress
        authPassWord = passWord
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let url = Constants.baseURL + Constants.tokenURL
        print("url: \(url)")
        let parameters = ["tourist":["email": authEmail, "password": authPassWord]]
        print("parameters: \(parameters)")
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in            
            switch response.result {
            case .success:
                let json: JSON = JSON(response.data as Any)
                print("json: \(json)")
                if let token = json["token"].string {
                    print("Action: logInAction, Message: Login successfully")
                    self.token = token
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(true, forKey: "isLogIn")
                    // If succeeded to login, fetch touristId from API server
                    self.getProfile()
                } else {
                    print("error: cannot parse json")
                    DispatchQueue.main.async {
                        self.passWordMessage.text = "authValidFail3".localized
                        self.passWordMessage.textColor = ThemeColor.errorString
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.passWordMessage.text = "authValidFail4".localized
                    self.passWordMessage.textColor = ThemeColor.errorString
                }
            }
        }
    }
    
    func setupUI() {
        signInTitle.text = "logInButtonText".localized
        emailField.placeholder = "emailInputPlace".localized
        passWordField.placeholder = "passwordInputPlace".localized
        passWordMessage.text = "signupErrorMessage".localized
        signinButtonText.setTitle("logInButtonText".localized, for: .normal)
    }
    
    func getProfile() {
        let headers: HTTPHeaders = ["Authorization": self.token]
        let url = Constants.baseURL + Constants.touristLoadURL
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let json: JSON = JSON(response.data as Any)
                print("json: \(json)")
                if json["id"].exists() {
                    print("Action: getProfile, Message: Succeeded to load tourist profile")
                    UserDefaults.standard.set(String(json["id"].int!), forKey: "id")
                    // To be considered: Save tourist profile if necessary
                    
                    // Move to Home controller
                    let tabBarVC = self.storyboard?.instantiateViewController(identifier: "homeTabBar") as! TabBarController
                    self.navigationController?.pushViewController(tabBarVC, animated: true)
                } else {
                    print("Action: getProfile, Message: Error. cannot parse json")
                }
            case .failure(let error):
                print("Action: getProfile, Message: Error. \(error)")
            }
        }
    }
    
    // Close keyboard when tapped on the areas which is not keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Close keyboard when tapped on "Return" key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Validation after editing textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailaddress = emailField.text, !emailaddress.contains("@"){
            passWordMessage.text = "emailValidMessage2".localized
            passWordMessage.textColor = ThemeColor.errorString
        }
    }
}
