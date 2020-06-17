//
//  ReviewPostViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/14.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON

class ReviewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    
    
    var spotId: Int?
    var apiKey = String()
    var ratingNum = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!

        postTextView.delegate = self
        // 自動的にキーボードを出す
        //postTextView.becomeFirstResponder()
        ratingStar.settings.updateOnTouch = true
        ratingStar.settings.fillMode = .half
        ratingStar.didTouchCosmos = { rating in
            self.ratingNum = rating
            self.ratingNumber.text = String(rating)
        }
    }
    
    // 入力画面もしくはkeyboard外押下時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.postTextView.isFirstResponder{
            self.postTextView.resignFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let postNum = postTextView.text.count
        textCount.text = String(postNum)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: Any) {
        // メールアドレスがnilでも空欄でもないことを確認
        guard let postReview = postTextView.text, !postReview.isEmpty else{
            errorMessage.text = "レビューを入力してください。"
            errorMessage.textColor = ThemeColor.errorString
            return
        }
        
        if postReview.count > 500{
            errorMessage.text = "500文字以内で入力してください。。"
            errorMessage.textColor = ThemeColor.errorString
        }else{
            // POSTするパラメータ作成
            let parameters = ["spot": String(spotId!), "apikey": apiKey,"review": postReview, "rating": ratingNum] as [String : Any]
            print(parameters)
            
            AF.request(Constants.postReviewURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
                print(response)
                
                switch response.result{
                
                case .success:
                    let json: JSON = JSON(response.data as Any)
                    let errorMessage = json["error"]["message"].string
                    if let errorMessage = errorMessage, !errorMessage.isEmpty {
                        // 送信失敗アラートを出す
                        let title = "レビュー失敗"
                        let message = errorMessage
                        let okText = "OK"
                        
                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okayButton)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        // 送信完了アラートを出す
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    }
}