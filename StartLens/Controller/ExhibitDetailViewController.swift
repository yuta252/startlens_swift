//
//  ExhibitDetailViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/15.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON


class ExhibitDetailViewController: UIViewController {

    @IBOutlet weak var exhibitImageView: UIImageView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var exhibitNameView: UILabel!
    @IBOutlet weak var exhibitIntroView: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    
    var apiKey = String()
    var spotId: Int?
    var exhibitObj: Exhibit?
    var exhibitId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        
        exhibitId = exhibitObj?.exhibitId
        
        setupUI()
        fetchData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        contentsView.layer.cornerRadius = 10.0
        contentsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let exhibitImageURL = URL(string: exhibitObj!.exhibitImage as String)
        exhibitImageView?.sd_setImage(with: exhibitImageURL, completed: { (image, error, _, _) in
             if error == nil{
                self.exhibitImageView.setNeedsLayout()
             }
         })
        exhibitNameView.text = exhibitObj?.exhibitName
    }
    
    func fetchData(){
        let text = Constants.exhibitDetailURL + apiKey + Constants.exhibitId + String(exhibitId!)
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            print(response)
            switch response.result{
                
            case .success:
                let json:JSON = JSON(response.data as Any)
                // レコメンドデータのParse
                if let exhibitIntro = json["result"]["intro"].string{
                    self.exhibitObj?.exhibitIntro = exhibitIntro
                    print(exhibitIntro)
                    DispatchQueue.main.async {
                        self.exhibitIntroView.text = exhibitIntro
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                        self.contentHeight.constant = self.exhibitIntroView.frame.size.height + 40
                        print(self.exhibitIntroView.frame.size.height + 40)
                    }
                    
                }
                break
            case .failure(let error):
                print(error)
                break
            }
            
        }
    }
}
