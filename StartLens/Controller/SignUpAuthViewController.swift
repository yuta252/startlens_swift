//
//  SignUpAuthViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/12.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpAuthViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var authExpText: UILabel!
    @IBOutlet weak var authFirstField: UITextField!
    @IBOutlet weak var authSecondField: UITextField!
    @IBOutlet weak var authThirdField: UITextField!
    @IBOutlet weak var authFourthField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    var authCode = Int()
    var apiKey = String()
    var emailAddress = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authFirstField.delegate = self
        authSecondField.delegate = self
        authThirdField.delegate = self
        authFourthField.delegate = self
        authExpText.text = "\(emailAddress) に認証コードを送信しました\n下記に認証コードを入力してください"
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if let authFirst = Int(authFirstField.text!), let authSecond = Int(authSecondField.text!), let authThird = Int(authThirdField.text!), let authFourth = Int(authFourthField.text!){
            
            let authInput = authFirst * 1000 + authSecond * 100 + authThird * 10 + authFourth
            
            if authCode == authInput {
                // 認証成功
                print("認証成功")
                // メールアドレスとパスワードをJSON形式でサーバーに送信する
                let parameters = ["auth":["email": emailAddress]]

                AF.request(Constants.signUpAuthURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
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
                            self.performSegue(withIdentifier: "signupcomplete", sender: nil)
                            
                        }else{
                            // 認証失敗
                            print("認証失敗")
                            DispatchQueue.main.async {
                                self.errorMessage.text = "認証に失敗しました。新規登録画面に戻りもう一度入力ください"
                            }
                        }

                    case .failure(let error):
                        print(error)
                        
                    }
                }
            }else{
                print("認証失敗")
                errorMessage.text = "認証コードが異なります。新規登録画面に戻りもう一度入力ください"
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let completeVC = segue.destination as? SignUpCompleteViewController
        completeVC?.emailAddress = emailAddress
        completeVC?.apiKey = apiKey
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
