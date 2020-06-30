//
//  ResetAuthViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/16.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResetAuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var authExpText: UILabel!
    @IBOutlet weak var authFirstField: UITextField!
    @IBOutlet weak var authSecondField: UITextField!
    @IBOutlet weak var authThirdField: UITextField!
    @IBOutlet weak var authFourthField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var loginButtonText: UIButton!
    @IBOutlet weak var resetButtonText: UIButton!
    @IBOutlet weak var backButtonText: UIButton!
    
    var authCode = Int()
    var apiKey = String()
    var emailAddress = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authFirstField.delegate = self
        authSecondField.delegate = self
        authThirdField.delegate = self
        authFourthField.delegate = self
        
        setupUI()
    }
    
    
    @IBAction func sendAction(_ sender: UIButton) {
        if let authFirst = Int(authFirstField.text!), let authSecond = Int(authSecondField.text!), let authThird = Int(authThirdField.text!), let authFourth = Int(authFourthField.text!){
            
            let authInput = authFirst * 1000 + authSecond * 100 + authThird * 10 + authFourth
            
            if authCode == authInput {
                // 認証成功
                // メールアドレスとパスワードをJSON形式でサーバーに送信する
                let parameters = ["auth":["email": emailAddress]]

                AF.request(Constants.passAuthURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
                    print(response)
                    
                    switch response.result{
                    
                    case .success:
                        let json: JSON = JSON(response.data as Any)
                        
                        if let authResult = json["result"]["authsuccess"].bool, authResult{
                            // APIキーを端末に登録
                            self.apiKey = json["result"]["apikey"].string!
                            UserDefaults.standard.set(self.apiKey, forKey: "apiKey")
                            UserDefaults.standard.set(true, forKey: "isLogIn")
                            // 認証完了画面へ遷移
                            switch sender.tag{
                            case 1:
                                // ログインして利用
                                self.performSegue(withIdentifier: "home", sender: nil)
                            case 2:
                                // パスワードの再設定
                                self.performSegue(withIdentifier: "passwordSend", sender: nil)
                            default:
                                self.performSegue(withIdentifier: "home", sender: nil)
                            }
                        }else{
                            // 認証失敗
                            print("認証失敗")
                            DispatchQueue.main.async {
                                self.errorMessage.text = "authValidFail1".localized
                                self.errorMessage.textColor = ThemeColor.errorString
                            }
                        }

                    case .failure(let error):
                        print(error)
                        
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.errorMessage.text = "authValidFail2".localized
                    self.errorMessage.textColor = ThemeColor.errorString
                }
            }
        }
    }
    

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        authExpText.text = "authExplainedText".localized
        loginButtonText.setTitle("useLoginButtonText".localized, for: .normal)
        resetButtonText.setTitle("resetPasswordButtonText".localized, for: .normal)
        backButtonText.setTitle("backPasswordResetText".localized, for: .normal)
    }
    
    
    // 文字数制限
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxlength: Int = 1
        // textFieldの文字数
        let textFieldNumber = textField.text?.count ?? 0
        // 入力された文字数
        let stringNumber = string.count
        
        return textFieldNumber + stringNumber <= maxlength
    }
    
    // キーボードを閉じる(Return key）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 現在のText Fieldからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号のTextFieldにフォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag){
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    // キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
