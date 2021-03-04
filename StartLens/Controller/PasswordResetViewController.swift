//
//  PasswordResetViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/16.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class PasswordResetViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate  {

    
    @IBOutlet weak var passwordResetText: UILabel!
    @IBOutlet weak var passwordRestSubText: UILabel!
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passWordMessage: UILabel!
    @IBOutlet weak var sendButtonText: UIButton!
    
    var authCode = Int()
    var authEmail = String()
    var language = String()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        language = UserDefaults.standard.string(forKey: "language") ?? "en"
        // プロトコル
        emailField.delegate = self
        
        setupUI()
        
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
        
        // POSTするパラメータ作成
        let parameters = ["auth":["email": emailAddress, "language": language]]
        
        // メールアドレスとパスワードをJSON形式でサーバーに送信する
        AF.request(Constants.passResetURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
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
                    if let authResult = json["result"]["authcode"].int{
                        self.authCode = authResult
                        self.performSegue(withIdentifier: "resetAuth", sender: nil)
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let authVC = segue.destination as? ResetAuthViewController
        authVC?.authCode = authCode
        authVC?.emailAddress = authEmail
    }
    
    func setupUI(){
        passwordResetText.text = "passwordResetTitleText".localized
        passwordRestSubText.text = "passwordResetSubText".localized
        emailField.placeholder = "emailInputPlace".localized
        sendButtonText.setTitle("sendButtonText".localized, for: .normal)
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
