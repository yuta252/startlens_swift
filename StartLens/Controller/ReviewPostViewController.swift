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

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    
    var token = String()
    var spotId = Int()
    var spot: Spot?
    var ratingNum: Double = 3.0
    var language = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial settings
        language = Language.getLanguage()
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else{
            // if cannot get a token, move to login screen
            print("Action: ViewDidLoad, Message: No token Error")
            return
        }
        token = savedToken
        spotId = self.spot!.id

        setupUI()
        postTextView.delegate = self

        setupRating()
    }
    
    // Close keyboard
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
        // Validation of posting review
        guard let postReview = postTextView.text, !postReview.isEmpty else {
            errorMessage.text = "reviewPostPlace".localized
            errorMessage.textColor = ThemeColor.errorString
            return
        }
        
        if postReview.count > 500 {
            errorMessage.text = "reviewPostHelp".localized
            errorMessage.textColor = ThemeColor.errorString
        } else {
            let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": self.token]
            let url = Constants.baseURL + Constants.reviewURL
            print("Action: postAction, url: \(url)")
            let parameters = ["review":["userId": self.spotId, "lang": self.language, "postReview": postReview, "rating": Int(self.ratingNum)]]
            print("Action: postAction, parameters: \(parameters)")
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                switch response.result {
                case .success:
                    let json: JSON = JSON(response.data as Any)
                    print("Action: postAction, json: \(json)")

                    if json["id"].int == nil {
                        // Failed to post review and pop up alert
                        let title = "reviewFailText".localized
                        let message = "reviewFailMessage".localized
                        let okText = "okButtonText".localized

                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okayButton)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // Successfully post review
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print("Action: postAction, Message: Error occured. \(error)")
                }
            }
        }
    }
    
    func setupUI() {
        cancelButton.title = "cancelButton".localized
        sendButton.title = "sendButtonText".localized
        errorMessage.text = "reviewPostHelp".localized
    }
    
    func setupRating() {
        ratingStar.settings.updateOnTouch = true
        ratingStar.settings.fillMode = .full
        ratingStar.didTouchCosmos = { rating in
            self.ratingNum = rating
            self.ratingNumber.text = String(rating)
        }
    }
}
