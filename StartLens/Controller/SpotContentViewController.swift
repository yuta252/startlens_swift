//
//  SpotContentViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/26.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import Cosmos

protocol SpotDetailDelegate: AnyObject{
    func getContentHeight(height: CGFloat)
    func moveToCamera()
    func moveToReviewPost()
    func moveToReviewContinue()
    func moveToExhibitContinue()
    // func moveToExhibitDetail(id: Int)
    func moveToExhibitDetail(Obj: Exhibit)
}


class SpotContentViewController: UIViewController {

    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var spotTitle: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var ratingAmount: UILabel!
    @IBOutlet weak var ratingItemText: UILabel!
    @IBOutlet weak var cameraButtonView: UIButton!
    @IBOutlet weak var likeButtonView: UIButton!
    @IBOutlet weak var spotIntroTitle: UILabel!
    @IBOutlet weak var spotIntroButton: UIButton!
    @IBOutlet weak var spotIntroView: UILabel!
    
    @IBOutlet weak var basicInfoTitle: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var telephoneTitle: UILabel!
    @IBOutlet weak var spotUrlTitle: UILabel!
    @IBOutlet weak var feeTitle: UILabel!
    @IBOutlet weak var businessHourTitle: UILabel!
    @IBOutlet weak var holidayTitle: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var spotUrl: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var holiday: UILabel!
    
    
    @IBOutlet weak var reviewTitleText: UILabel!
    @IBOutlet weak var reviewPostButton: UIButton!
    
    @IBOutlet weak var noReview: UILabel!
    @IBOutlet weak var reviewContinueButton: UIButton!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var recommendTitleText: UILabel!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var noRecommend: UILabel!
    @IBOutlet weak var recommendContinueButton: UIButton!
    
    var apiKey = String()
    var delegate: SpotDetailDelegate?
    var contentHeight: CGFloat?
    var spotId: Int?
    var variable = String()
    var language = String()
    
    var isLike = false
    var isIntroExtend = false
    var reviewItem = [Review]()
    var exhibitItem = [Exhibit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        language = UserDefaults.standard.string(forKey: "language")!
        setupUI()
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.register(UINib(nibName: "WriterCell", bundle: nil), forCellReuseIdentifier: "WriterCell")
        reviewTableView.estimatedRowHeight = 110
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.separatorStyle = .none
        reviewTableView.bounces = false
        reviewTableView.isScrollEnabled = false
        
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.register(UINib(nibName: "RecommendCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        
        fetchData()
        reviewTableView.reloadData()
        recommendCollectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableHeight.constant = reviewTableView.contentSize.height
        collectionHeight.constant = recommendCollectionView.contentSize.height
        // SpotDetailViewControllerに高さを渡す
        contentHeight = contentView.frame.origin.y + contentView.frame.size.height
        print("contentHeight1: \(contentHeight!)")
        self.delegate?.getContentHeight(height: contentHeight!)
    }
    
    func setupUI(){
        contentView.layer.cornerRadius = 10.0
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.layer.cornerRadius = 10.0
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cameraButtonView.layer.cornerRadius = 30.0
        likeButtonView.layer.cornerRadius = 10.0
        reviewPostButton.layer.cornerRadius = 5.0
        reviewPostButton.layer.borderWidth = 1.0
        reviewPostButton.layer.borderColor = ThemeColor.main.cgColor
        reviewContinueButton.layer.cornerRadius = 5.0
        reviewContinueButton.layer.borderWidth = 1.0
        reviewContinueButton.layer.borderColor = ThemeColor.main.cgColor
        recommendContinueButton.layer.cornerRadius = 5.0
        recommendContinueButton.layer.borderWidth = 1.0
        recommendContinueButton.layer.borderColor = ThemeColor.main.cgColor
        
        ratingItemText.text = "spotRatingItemText".localized
        spotIntroTitle.text = "spotIntroTitle".localized
        basicInfoTitle.text = "spotBasicInfoTitle".localized
        addressTitle.text = "spotBasicLocation".localized
        telephoneTitle.text = "spotBasicTel".localized
        spotUrlTitle.text = "spotBasicHp".localized
        feeTitle.text = "spotBasicExpense".localized
        businessHourTitle.text = "spotBasicBusiness".localized
        holidayTitle.text = "spotBasicHoliday".localized
        reviewTitleText.text = "Review".localized
        noReview.text = "noReviewText".localized
        reviewPostButton.setTitle("reviewPostButton".localized, for: .normal)
        reviewContinueButton.setTitle("reviewContinueButton".localized, for: .normal)
        recommendTitleText.text = "recommendTitleText".localized
        noRecommend.text = "noRecommendText".localized
        recommendContinueButton.setTitle("recommedContinueButton".localized, for: .normal)
    }
    
    
    @IBAction func cameraAction(_ sender: Any) {
        self.delegate?.moveToCamera()
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if isLike{
            // Likeの場合Likeを消去する
            self.likeButtonView.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeButtonView.tintColor = .lightGray
            self.likeButtonView.backgroundColor = ThemeColor.secondString
            self.isLike = false
            self.likeUpdate(isLike: false, spotId: String(spotId!))
        }else{
            // Likeに追加する
            self.likeButtonView.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.likeButtonView.tintColor = UIColor.white
            self.likeButtonView.backgroundColor = ThemeColor.errorString
            self.isLike = true
            self.likeUpdate(isLike: true, spotId: String(spotId!))
        }
    }
    
    
    @IBAction func introExtendAction(_ sender: Any) {
        if isIntroExtend{
            // 説明文を閉じる
            spotIntroView.numberOfLines = 3
            spotIntroButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            isIntroExtend = false
        }else{
            // 説明文を開く
            spotIntroView.numberOfLines = 0
            spotIntroButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            isIntroExtend = true
        }
        
        // 遅延処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
            self.contentHeight = self.contentView.frame.origin.y + self.contentView.frame.size.height
            print("contentHeight1: \(self.contentHeight!)")
            self.delegate?.getContentHeight(height: self.contentHeight!)
        }
    }
    
    @IBAction func reviewPostAction(_ sender: Any) {
        self.delegate?.moveToReviewPost()
    }
    
    @IBAction func reviewContinueAction(_ sender: Any) {
        self.delegate?.moveToReviewContinue()
    }
    
    @IBAction func exhibitContinueAction(_ sender: Any) {
        self.delegate?.moveToExhibitContinue()
    }
    
    
    
    
    func fetchData(){
        
        let text = Constants.spotDetailURL + apiKey + Constants.spot + String(spotId!) + Constants.lang + language
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            print(response)
            switch response.result{
                
            case .success:
                let json:JSON = JSON(response.data as Any)
                
                // spotデータのParse
                let spotImageURL = URL(string: json["result"]["spot"]["thumbnail"].string!)
                self.spotImageView?.sd_setImage(with: spotImageURL, completed: { (image, error, _, _) in
                    if error == nil{
                        self.spotImageView.setNeedsLayout()
                    }
                })
                self.spotTitle.text = json["result"]["spot"]["spotTitle"].string!
                self.category.text = json["result"]["spot"]["category"].string!
                self.ratingStar.settings.updateOnTouch = false
                self.ratingStar.rating = Double(json["result"]["spot"]["ratingstar"].float!)
                self.ratingStar.settings.fillMode = .half
                self.ratingNumber.text = String(json["result"]["spot"]["ratingstar"].float!)
                self.ratingAmount.text = String(json["result"]["spot"]["ratingAmount"].int!)
                self.isLike = json["result"]["spot"]["like"].bool!
                if self.isLike{
                    self.likeButtonView.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.likeButtonView.tintColor = UIColor.white
                    self.likeButtonView.backgroundColor = ThemeColor.errorString
                }else{
                    self.likeButtonView.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.likeButtonView.tintColor = .lightGray
                    self.likeButtonView.backgroundColor = ThemeColor.secondString
                }
                self.spotIntroView.text = json["result"]["spot"]["intro"].string!
                
                if let address = json["result"]["spot"]["address"].string, !address.isEmpty{
                    self.address.text = address
                }
                if let telephone = json["result"]["spot"]["telephone"].string, !telephone.isEmpty{
                    self.telephone.text = telephone
                }
                if let url = json["result"]["spot"]["url"].string, !url.isEmpty{
                    self.spotUrl.text = url
                }
                if let fee = json["result"]["spot"]["fee"].string, !fee.isEmpty{
                    self.fee.text = fee
                }
                if let businessHour = json["result"]["spot"]["businessHour"].string, !businessHour.isEmpty{
                    self.businessHour.text = businessHour
                }
                if let holiday = json["result"]["spot"]["holiday"].string, !holiday.isEmpty{
                    self.holiday.text = holiday
                }
                
                // レビューデータのParse
                if let num = json["info"]["reviewNum"].int, num != 0{
                    self.noReview.isHidden = true
                    self.noReview.isHidden = true
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
                    self.noReview.isHidden = false
                    self.reviewContinueButton.isHidden = true
                }
                
                // レコメンドデータのParse
                if let num = json["info"]["recommendNum"].int, num != 0{
                    self.noRecommend.isHidden = true
                    self.noRecommend.isHidden = true
                    self.exhibitItem = []
                    let roopNum = num - 1

                    for i in 0...roopNum{
                        let exhibitId = json["result"]["recommend"][i]["exhibitId"].int
                        let exhibitName =  json["result"]["recommend"][i]["exhibitName"].string
                        let exhibitUrl = json["result"]["recommend"][i]["exhibitUrl"].string
                        print("exhibitName: \(exhibitName!), exhibitUrl: \(exhibitUrl!)")
                        let exhibit: Exhibit = Exhibit(exhibitId: exhibitId!, exhibitName: exhibitName!, exhibitImage: exhibitUrl!, exhibitIntro: "like")
                        self.exhibitItem.append(exhibit)
                    }
                    print("exhibitItem: \(self.exhibitItem)")
                }else{
                    // 検索結果がない場合
                    self.noRecommend.isHidden = false
                    self.noRecommend.isHidden = false
                    self.recommendContinueButton.isHidden = true
                }

                break
            case .failure(let error):
                print(error)
                break
            }
            
            self.reviewTableView.reloadData()
            self.recommendCollectionView.reloadData()
            // 画像読み込み後再度高さ設定
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                self.contentHeight = self.contentView.frame.origin.y + self.contentView.frame.size.height
                self.delegate?.getContentHeight(height: self.contentHeight!)
            }
        }
    }
    
    func likeUpdate(isLike: Bool, spotId: String){
        var text = String()
        if isLike {
            // 登録
            text = Constants.likeURL + apiKey + Constants.spot + spotId + Constants.islike + "1"
        }else{
            // 削除
            text = Constants.likeURL + apiKey + Constants.spot + spotId + Constants.islike + "0"
        }
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            print(response)
            switch response.result{
            case .success:
                let json:JSON = JSON(response.data as Any)
                let isSaved:Bool = json["result"]["like"].bool!
                
                if isSaved{
                    print("正常に処理終了")
                }
                
                break
            case .failure(let error):
                print(error)
                break
            }

        }
    }
}


extension SpotContentViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cell is counted")
        return reviewItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriterCell", for: indexPath) as! WriterCell
        print("cell is created")

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

extension SpotContentViewController:UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension SpotContentViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibitItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as! RecommendCell
        cell.exhibitName.text = exhibitItem[indexPath.row].exhibitName
        
        let exhibitImageURL = URL(string: self.exhibitItem[indexPath.row].exhibitImage as String)
        // 画像の高速化処理
        cell.exhibitImageView?.sd_setImage(with: exhibitImageURL, completed: { (image, error, _, _) in
            if error == nil{
                cell.setNeedsLayout()
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.moveToExhibitDetail(Obj: self.exhibitItem[indexPath.row])
        // self.delegate?.moveToExhibitDetail(id: self.exhibitItem[indexPath.row].exhibitId)
    }
}

extension SpotContentViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellWidth:CGFloat = (self.view.bounds.width - horizontalSpace - 40)/2
        print("collectionview is called: \(cellWidth)")
        let cellHeight:CGFloat = cellWidth + 50
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

