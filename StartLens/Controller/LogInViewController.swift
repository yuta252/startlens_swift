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

    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passWordField: HoshiTextField!
    @IBOutlet weak var passWordMessage: UILabel!
    @IBOutlet weak var signinButtonText: UIButton!
    @IBOutlet weak var passwordResetText: UIButton!
    
    
    var authCode = Int()
    var authEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // プロトコル
        emailField.delegate = self
        passWordField.delegate = self
        
        setupUI()
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        // メールアドレスがnilでも空欄でもないことを確認
        guard let emailAddress = emailField.text, !emailAddress.isEmpty else{
            passWordMessage.text = "emailValidMessage".localized
            passWordMessage.textColor = ThemeColor.errorString
            return
        }
        
        authEmail = emailAddress
        
        // パスワードがnilでも空欄でもないことを確認
        guard let passWord = passWordField.text, !passWord.isEmpty else{
            passWordMessage.text = "passValidMessage".localized
            passWordMessage.textColor = ThemeColor.errorString
            return
        }
        
        // POSTするパラメータ作成
        let parameters = ["auth":["email": emailAddress, "password": passWord]]
        
        // メールアドレスとパスワードをJSON形式でサーバーに送信する
        AF.request(Constants.logInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
            
            switch response.result{
            
            case .success:
                let json: JSON = JSON(response.data as Any)
                let errorMessage = json["error"]["message"].string
                if let errorMessage = errorMessage, !errorMessage.isEmpty {
                    print("Empty error message")
                    DispatchQueue.main.async {
                        self.passWordMessage.text = String(errorMessage)
                        self.passWordMessage.textColor = ThemeColor.errorString
                    }
                    
                }else{
                    // 認証コード画面へ遷移
                    if let isLogin = json["result"]["authsuccess"].bool, isLogin{
                        if let apiKey = json["result"]["apikey"].string{
                            UserDefaults.standard.set(apiKey, forKey: "apiKey")
                            self.performSegue(withIdentifier: "home", sender: nil)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    @IBAction func passWordResetAction(_ sender: Any) {
        // パスワードリセット画面に遷移
        performSegue(withIdentifier: "passwordRest", sender: nil)
    }
    
    func setupUI(){
        emailField.placeholder = "emailInputPlace".localized
        passWordField.placeholder = "passwordInputPlace".localized
        passWordMessage.text = "signupErrorMessage".localized
        signinButtonText.setTitle("logInButtonText".localized, for: .normal)
        passwordResetText.setTitle("passwordFogotText".localized, for: .normal)
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
            passWordMessage.text = "emailValidMessage2"
            passWordMessage.textColor = ThemeColor.errorString
        }
    }
}
