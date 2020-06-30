//
//  ContactViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/28.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contactTitle: UILabel!
    @IBOutlet weak var contactContent: PlaceHolderedTextView!
    @IBOutlet weak var contactHelp: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var apiKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!

        setupUI()
    }
    
    // 入力画面もしくはkeyboard外押下時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.contactContent.isFirstResponder{
            self.contactContent.resignFirstResponder()
        }
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        // レビューが空欄でないことを確認
        guard let postContact = contactContent.text, !postContact.isEmpty else{
            contactHelp.text = "contactHelpText2".localized
            contactHelp.textColor = ThemeColor.errorString
            return
        }
        
        if postContact.count > 1000{
            contactHelp.text = "contactHelpText".localized
            contactHelp.textColor = ThemeColor.errorString
        }else{
            // POSTするパラメータ作成
            let parameters = ["apikey": apiKey,"contact": postContact]
            print(parameters)
            
            AF.request(Constants.contactURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
                print(response)
                
                switch response.result{
                
                case .success:
                    let json: JSON = JSON(response.data as Any)
                    let errorMessage = json["error"]["message"].string
                    if let errorMessage = errorMessage, !errorMessage.isEmpty {
                        // 送信失敗アラートを出す
                        let title = "contactFailTitle".localized
                        let message = "contactFailText".localized
                        let okText = "okButtonText".localized
                        
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okayButton)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.contactContent.text = ""
                        // 送信完了アラートを出す
                        let title = "contactSuccessTitle".localized
                        let message = "contactSuccessText".localized
                        let okText = "okButtonText".localized
                        
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okayButton)
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
        
    }
    
    func setupUI(){
        contactTitle.text = "settingContactTitle".localized
        // contactContent.placeholder
        contactHelp.text = "contactHelpText".localized
        sendButton.setTitle("sendButtonText".localized, for: .normal)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
