//
//  PassSendViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/16.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class PassSendViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var passWordField: HoshiTextField!
    @IBOutlet weak var passWordMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // プロトコル
        passWordField.delegate = self
        
        
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        // パスワードがnilでも空欄でもないことを確認
        guard let passWord = passWordField.text, !passWord.isEmpty else{
            passWordMessage.text = "パスワードを入力してください"
            passWordMessage.textColor = ThemeColor.errorString
            print("パスワード入力ないよ")
            return
        }
        
        // POSTするパラメータ作成
        let apikey = UserDefaults.standard.string(forKey: "apiKey")
        let parameters = ["auth":["apikey": apikey, "password": passWord]]
        
        // メールアドレスとパスワードをJSON形式でサーバーに送信する
        AF.request(Constants.passSendURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
            
            switch response.result{
            
            case .success:
                self.performSegue(withIdentifier: "home", sender: nil)
            case .failure(let error):
                print(error)
                
            }
        }
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
}


