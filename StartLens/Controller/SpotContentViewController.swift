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


protocol SpotDetailDelegate: AnyObject {
    func getContentHeight(height: CGFloat)
    func moveToCamera(exhibits: [Exhibit])
    func moveToReviewPost()
    func moveToReviewContinue()
    func moveToExhibitContinue(exhibits: [Exhibit])
    func moveToExhibitDetail(exhibit: Exhibit)
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
    
    var token = String()
    var contentHeight: CGFloat?
    var spot: Spot?
    var spotId: Int?
    var variable = String()
    var language = String()
    var isFavorite = false
    var isIntroExtend = false
    var reviews = [Review]()
    var exhibits: [Exhibit]?
    var format = ISO8601DateFormatter()
    
    var delegate: SpotDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial settings
        language = Language.getLanguage()
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else {
            // if cannot get a token, move to login screen
            print("Action: ViewDidLoad, Message: No token Error")
            return
        }
        token = savedToken
        self.reviews = self.spot!.reviews
        
        // UI settings
        setupData()
        setupUI()
        setupTableView()
        setupCollectionView()
        
        // Data settings
        fetchData()
        reviewTableView.reloadData()
        print("Action: viewDidLoad, Message: recommendCollectionView is called")
        recommendCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableHeight.constant = reviewTableView.contentSize.height
        collectionHeight.constant = recommendCollectionView.contentSize.height
        // Send content height to SpotDetailVC
        contentHeight = contentView.frame.origin.y + contentView.frame.size.height
        self.delegate?.getContentHeight(height: contentHeight!)
        print("Action: viewDidAppear, contentHeight: \(contentHeight!)")
    }
    
    func setupUI() {
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

        if self.isFavorite {
            self.likeButtonView.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.likeButtonView.tintColor = UIColor.white
            self.likeButtonView.backgroundColor = ThemeColor.errorString
        } else {
            self.likeButtonView.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeButtonView.tintColor = .lightGray
            self.likeButtonView.backgroundColor = ThemeColor.secondString
        }
        
        if self.reviews.count != 0 {
            self.noReview.isHidden = true
            self.noReview.isHidden = true
        } else {
            // No review
            self.noReview.isHidden = false
            self.noReview.isHidden = false
            self.reviewContinueButton.isHidden = true
        }
        
        // Date format
        format.formatOptions = .withFullDate
        
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
    
    func setupData() {
        self.spotId = self.spot?.id
        let spotImageURL: URL?
        if let url = spot?.profile.url {
            spotImageURL = URL(string: url)
        } else {
            spotImageURL = URL(fileURLWithPath: Bundle.main.path(forResource: "toppage_1", ofType: "jpg")!)
        }
        self.spotImageView?.sd_setImage(with: spotImageURL, completed: { (image, error, _, _) in
            if error == nil{
                self.spotImageView.setNeedsLayout()
            }
        })
        let multiProfile: MultiProfile = self.spot!.selectMultiProfileByLang(lang: self.language)
        self.spotTitle.text = multiProfile.username
        self.category.text = Constants.majorCategoryMap[spot?.profile.majorCategory ?? 0]
        self.ratingStar.settings.updateOnTouch = false
        self.ratingStar.rating = Double(spot?.profile.rating ?? 0.0)
        self.ratingStar.settings.fillMode = .half
        self.ratingNumber.text = String(spot?.profile.rating ?? 0.0)
        self.ratingAmount.text = String(spot?.profile.ratingCount ?? 0)
        if let isFavorite = spot?.isFavorite {
            self.isFavorite = isFavorite
        }
        self.spotIntroView.text = multiProfile.selfIntro
        self.address.text = multiProfile.addressPrefecture + multiProfile.addressCity + multiProfile.addressCity
        self.telephone.text = spot?.profile.telephone
        self.spotUrl.text = spot?.profile.companySite
        self.fee.text = multiProfile.entranceFee
        self.businessHour.text = multiProfile.businessHours
        self.holiday.text = multiProfile.holiday
    }
    
    func setupTableView() {
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.register(UINib(nibName: "WriterCell", bundle: nil), forCellReuseIdentifier: "WriterCell")
        reviewTableView.estimatedRowHeight = 110
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.separatorStyle = .none
        reviewTableView.bounces = false
        reviewTableView.isScrollEnabled = false
    }
    
    func setupCollectionView() {
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.register(UINib(nibName: "RecommendCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        self.delegate?.moveToCamera(exhibits: self.exhibits!)
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if isFavorite {
            // Remove like if has already been favorite
            self.likeButtonView.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeButtonView.tintColor = .lightGray
            self.likeButtonView.backgroundColor = ThemeColor.secondString
            self.isFavorite = false
            self.spot?.removeFavorite(token: self.token, spotId: self.spotId!)
        } else {
            // Add like if has never been favorite
            self.likeButtonView.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.likeButtonView.tintColor = UIColor.white
            self.likeButtonView.backgroundColor = ThemeColor.errorString
            self.isFavorite = true
            self.spot?.addFavorite(token: self.token, spotId: self.spotId!)
        }
    }
    
    @IBAction func introExtendAction(_ sender: Any) {
        if isIntroExtend {
            // Close spot introduction view
            spotIntroView.numberOfLines = 3
            spotIntroButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            isIntroExtend = false
        } else {
            // Open spot introduction view
            spotIntroView.numberOfLines = 0
            spotIntroButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            isIntroExtend = true
        }
        
        // Delay processing to update content height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.contentHeight = self.contentView.frame.origin.y + self.contentView.frame.size.height
            self.delegate?.getContentHeight(height: self.contentHeight!)
            print("Action: introExtendAction, contentHeight: \(self.contentHeight!)")
        }
    }
    
    @IBAction func reviewPostAction(_ sender: Any) {
        self.delegate?.moveToReviewPost()
    }
    
    @IBAction func reviewContinueAction(_ sender: Any) {
        self.delegate?.moveToReviewContinue()
    }
    
    @IBAction func exhibitContinueAction(_ sender: Any) {
        self.delegate?.moveToExhibitContinue(exhibits: self.exhibits!)
    }
    
    func fetchData() {
        let url = Constants.baseURL + Constants.exhibitURL + "/" + String(self.spot!.id)
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("Action: fetchData, url: \(encodedUrl)")
        AF.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            switch response.result {
            case .success:                
                self.exhibits = try? JSONDecoder().decode([Exhibit].self, from: response.data!)
                
                if let num = self.exhibits?.count, num != 0{
                    self.noRecommend.isHidden = true
                } else {
                    // No exhibit data
                    self.noRecommend.isHidden = false
                    self.recommendContinueButton.isHidden = true
                }
            case .failure(let error):
                print("Action: fetchData, Message: Error occured \(error)")
            }
            
            // self.reviewTableView.reloadData()
            print("Action: fetchData, Message: recommendCollectionView reload is called")
            self.recommendCollectionView.reloadData()
            // Set contents heights after loading exhibit data
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                self.contentHeight = self.contentView.frame.origin.y + self.contentView.frame.size.height
                self.delegate?.getContentHeight(height: self.contentHeight!)
            }
        }
    }
}


extension SpotContentViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: reviewは最大3つ表示する
        // return self.reviews.count
        return min(self.reviews.count, 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriterCell", for: indexPath) as! WriterCell
        print("cell is created")

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.writerName.text = self.reviews[indexPath.row].tourist.username
        // Format date to string
        let date = format.date(from: self.reviews[indexPath.row].createdAt)
        cell.postedDate.text = format.string(from: date!)
        // Cosmos
        cell.ratingStar.settings.updateOnTouch = false
        cell.ratingStar.rating = Double(self.reviews[indexPath.row].rating)
        cell.ratingStar.settings.fillMode = .half
        cell.ratingNumber.text = String(self.reviews[indexPath.row].rating)
        cell.reviewPosted.text = self.reviews[indexPath.row].postReview
        return cell
    }
}

extension SpotContentViewController:UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension SpotContentViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Action: numberOfItemsInSection, exhibits count: \(exhibits?.count ?? 0)")
        let exhibitsNum = self.exhibits?.count ?? 0
        return min(exhibitsNum, 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Action: CellForItemAt, Message: cellForItemAt is called")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as! RecommendCell
        let multiExhibit = self.exhibits?[indexPath.row].selectMultiExhibitByLang(lang: language)
        cell.exhibitName.text = multiExhibit?.name
        let exhibitImageURL: URL?
        if let url = self.exhibits?[indexPath.row].pictures[0].url {
            exhibitImageURL = URL(string: url)
        } else {
            exhibitImageURL = URL(fileURLWithPath: Bundle.main.path(forResource: "noimage", ofType: "png")!)
        }
        cell.exhibitImageView?.sd_setImage(with: exhibitImageURL, completed: { (image, error, _, _) in
            if error == nil{
                cell.setNeedsLayout()
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.moveToExhibitDetail(exhibit: self.exhibits![indexPath.row])
    }
}

extension SpotContentViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellWidth:CGFloat = (self.view.bounds.width - horizontalSpace - 40)/2
        print("Action: collectionView, cellWidth: \(cellWidth)")
        let cellHeight:CGFloat = cellWidth + 50
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

