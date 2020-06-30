//
//  SignUpViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/09.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passWordField: HoshiTextField!
    @IBOutlet weak var passWordMessage: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    var authCode = Int()
    var authEmail = String()
    var language = String()
    var country = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passWordField.delegate = self
        
        setupUI()
        language = UserDefaults.standard.string(forKey: "language") ?? "en"
        country = UserDefaults.standard.string(forKey: "country") ?? "NA"
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        // メールアドレスがnilでも空欄でもないことを確認
        guard let emailAddress = emailField.text, !emailAddress.isEmpty else{
            passWordMessage.text = "emailValidMessage".localized
            passWordMessage.textColor = ThemeColor.errorString
            return
        }
        
        authEmail = emailAddress
        
        // パスワードがnilでも空欄でもないことを確認
        guard let passWord = passWordField.text, !passWord.isEmpty else{
            passWordMessage.text = "passwordValidMessage".localized
            passWordMessage.textColor = ThemeColor.errorString
            return
        }
        
        // POSTするパラメータ作成
        let parameters = ["auth":["email": emailAddress, "password": passWord, "language": language, "country": country]]
        print("parameters: \(parameters)")
        // メールアドレスとパスワードをJSON形式でサーバーに送信する
        AF.request(Constants.signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
            
            switch response.result{
            
            case .success:
                let json: JSON = JSON(response.data as Any)
                let errorMessage = json["error"]["message"].string
                if let errorMessage = errorMessage, !errorMessage.isEmpty {
                    DispatchQueue.main.async {
                        self.passWordMessage.text = String(errorMessage)
                        self.passWordMessage.textColor = ThemeColor.errorString
                    }
                    
                }else{
                    // 認証コード画面へ遷
                    if let authResult = json["result"]["authcode"].int{
                        self.authCode = authResult
                        self.performSegue(withIdentifier: "auth", sender: nil)
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let authVC = segue.destination as? SignUpAuthViewController
        print("Sign up view controller ,prepare segue authCode: \(authCode)")
        authVC?.authCode = self.authCode
        authVC?.emailAddress = self.authEmail
    }
    
    func setupUI(){
        navigationBar.tintColor = UIColor.white
        emailField.placeholder = "emailInputPlace".localized
        passWordField.placeholder = "passwordInputPlace".localized
        passWordMessage.text = "signupErrorMessage".localized
        sendButton.setTitle("signupSendText".localized, for: .normal)
        
    }
    
    // キーボード以外の領域を押下時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // キーボードをReturnで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailaddress = emailField.text, !emailaddress.contains("@"){
            passWordMessage.text = "emailValidMessage2".localized
            passWordMessage.textColor = ThemeColor.errorString
        }
    }
}


