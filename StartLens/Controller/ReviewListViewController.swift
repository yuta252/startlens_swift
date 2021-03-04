//
//  ReviewListViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/15.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ReviewListViewController: UIViewController {

    @IBOutlet weak var reviewTitleText: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var noReview: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    var apiKey = String()
    var spotId: Int?
    var language = String()
    var reviewItem = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        
        setupUI()
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.register(UINib(nibName: "WriterCell", bundle: nil), forCellReuseIdentifier: "WriterCell")
        reviewTableView.estimatedRowHeight = 110
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.separatorStyle = .none
        reviewTableView.bounces = false
        reviewTableView.isScrollEnabled = false
        
        fetchData()
        reviewTableView.reloadData()

    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI(){
        reviewTitleText.text = "revewListTitle".localized
        noReview.text = "noReviewText".localized
    }
    
    func fetchData(){
        let text = Constants.reviewListURL + apiKey + Constants.spot + String(spotId!) + Constants.lang + language
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            print(response)
            switch response.result{
                
            case .success:
                self.noReview.isHidden = true
                let json:JSON = JSON(response.data as Any)
                // レビューデータのParse
                if let num = json["info"]["reviewNum"].int, num != 0{
                    self.reviewItem = []
                    let roopNum = num - 1

                    for i in 0...roopNum{
                        let writer = json["result"]["review"][i]["writer"].string
                        let ratingStar = json["result"]["review"][i]["ratingstar"].float
                        let postedReview = json["result"]["review"][i]["postedreview"].string
                        let postedDate = json["result"]["review"][i]["posteddate"].string
                        let review:Review = Review(writerName: writer!, ratingStar: ratingStar!, postDate: postedDate!, reviewPosted: postedReview!)
                        self.reviewItem.append(review)
                        
                    }
                    print("reviewItem: \(self.reviewItem)")
                }else{
                    // 検索結果がない場合
                    self.noReview.isHidden = false
                }

                break
            case .failure(let error):
                print(error)
                break
            }
            
            self.reviewTableView.reloadData()
            self.tableViewHeight.constant = self.reviewTableView.contentSize.height
        }
    
    }
}


extension ReviewListViewController: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


extension ReviewListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriterCell", for: indexPath) as! WriterCell

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.writerName.text = reviewItem[indexPath.row].writerName
        cell.postedDate.text = reviewItem[indexPath.row].postDate
        // Cosmos
        cell.ratingStar.settings.updateOnTouch = false
        cell.ratingStar.rating = Double(reviewItem[indexPath.row].ratingStar)
        cell.ratingStar.settings.fillMode = .half
        cell.ratingNumber.text = String(reviewItem[indexPath.row].ratingStar)
        cell.reviewPosted.text = reviewItem[indexPath.row].reviewPosted
        
        return cell
    }
    
    
}
