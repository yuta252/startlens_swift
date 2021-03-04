//
//  HomeViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/17.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreLocation


class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightContent: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var searchTitleText: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var searchButtonText: UIButton!
    @IBOutlet weak var spotlistTitleText: UILabel!
    @IBOutlet weak var noSearchTitle: UILabel!
    @IBOutlet weak var noSearchSubtitle: UILabel!
    
    var spotItem = [Spot]()
    var apiKey = String()
    var language = String()
    var searchBar: UISearchBar!
    var searchQuery: String = "all"
    var locationQuery: String = "all"
    var categoryQuery: String = "all"
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var spotId: Int?
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        language = UserDefaults.standard.string(forKey: "language")!
        setupUI()
        // TabaleView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.isScrollEnabled = false
        
        scrollView.delegate = self
        scrollView.bounces = false
        // NavigationBarに検索バーを設定
        setSearchBar()
        
        fetchData(query: "all")
        tableView.reloadData()
        // Location Managerの設定
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //spotItem = []
        // 位置情報の取得開始
        locationManager.startUpdatingLocation()
        // 遅延処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.fetchData(address: self.locationQuery, category: self.categoryQuery)
        }
    }
    
    func setupUI(){
        locationButton.layer.cornerRadius = 5.0
        locationButton.layer.borderColor = UIColor.lightGray.cgColor
        locationButton.layer.borderWidth = 1.0
        locationButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        categoryButton.layer.cornerRadius = 5.0
        categoryButton.layer.borderColor = UIColor.lightGray.cgColor
        categoryButton.layer.borderWidth = 1.0
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        searchTitleText.text = "searchTitleText".localized
        locationButton.setTitle("searchLocationPlace".localized, for: .normal)
        categoryButton.setTitle("searchCategoryPlace".localized, for: .normal)
        searchButtonText.setTitle("searchButtonText".localized, for: .normal)
        spotlistTitleText.text = "spotlistTitleText".localized
        noSearchTitle.text = "noSearchResultText".localized
        noSearchSubtitle.text = "noSearchResultHelp".localized
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        // 位置情報取得許可ダイアログの表示
        guard let locationManager = locationManager else {return}
        locationManager.requestWhenInUseAuthorization()
        // ステータスごとの処理
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse{
            locationManager.delegate = self
            // 位置情報の更新頻度
            locationManager.distanceFilter = 100
            // 位置情報の取得
            locationManager.startUpdatingLocation()
            // 遅延処理
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                self.fetchData(address: self.locationQuery, category: "all")
            }
            locationButton.setTitle("currentLocationText".localized, for: .normal)
            locationButton.setTitleColor(ThemeColor.firstString, for: .normal)
        }
    }
    
    @IBAction func locationSearchAction(_ sender: Any) {
        performSegue(withIdentifier: "location", sender: nil)
    }
    
    @IBAction func categorySearchAction(_ sender: Any) {
        performSegue(withIdentifier: "category", sender: nil)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        fetchData(address: locationQuery, category: categoryQuery)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier{
        case "category":
            let categoryVC = segue.destination as! CategoryListViewController
            categoryVC.delegate = self
            break
        case "location":
            let locationVC = segue.destination as! LocationViewController
            locationVC.delegate = self
            break
        case "spotdetail":
            let spotDetailVC = segue.destination as! SpotDetailViewController
            spotDetailVC.spotId = spotId
        default:
            break
        }
        
    }
    
    
    // クエリによるデータの抽出
    func fetchData(query: String){
        
        let text = Constants.homeURL + apiKey + Constants.query + query
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            print(response)
            switch response.result{
                
            case .success:
                let json:JSON = JSON(response.data as Any)
                self.spotItem = []
                if let num = json["info"]["num"].int, num != 0{
                    self.noSearchTitle.isHidden = true
                    self.noSearchSubtitle.isHidden = true
                    let roopNum = num - 1

                    for i in 0...roopNum{
                        let spotTitle = json["result"][i]["spotTitle"].string
                        let category = json["result"][i]["category"].string
                        let imageURLString = json["result"][i]["thumbnail"].string
                        let address = json["result"][i]["address"].string
                        let ratingStar = json["result"][i]["ratingstar"].float
                        let ratingAmount = json["result"][i]["ratingAmount"].int
                        let spotPk = json["result"][i]["spotpk"].int
                        let isLike = json["result"][i]["like"].bool
                        let spot:Spot = Spot(spotTitle: spotTitle!, category: category!, thumbnail: imageURLString!, address: address!, ratingStar: ratingStar!, ratingAmount: ratingAmount!, spotPk: spotPk!, isLike: isLike!)
                        self.spotItem.append(spot)
                        
                    }
                    print("spotItem: \(self.spotItem)")
                }else{
                    // 検索結果がない場合
                    self.noSearchTitle.isHidden = false
                    self.noSearchSubtitle.isHidden = false
                }
                
                break
            case .failure(let error):
                print(error)
                break
            }
            
            self.tableView.reloadData()
        }
    }
    
    // 場所カテゴリー検索による抽出
    func fetchData(address: String, category: String){
        
        let text = Constants.searchURL + apiKey + Constants.category + category + Constants.address + address + Constants.lang + language
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            print(response)
            switch response.result{
                
            case .success:
                let json:JSON = JSON(response.data as Any)
                self.spotItem = []
                if let num = json["info"]["num"].int, num != 0{
                    self.noSearchTitle.isHidden = true
                    self.noSearchSubtitle.isHidden = true
                    let roopNum = num - 1

                    for i in 0...roopNum{
                        let spotTitle = json["result"][i]["spotTitle"].string
                        let category = json["result"][i]["category"].string
                        let imageURLString = json["result"][i]["thumbnail"].string
                        let address = json["result"][i]["address"].string
                        let ratingStar = json["result"][i]["ratingstar"].float
                        let ratingAmount = json["result"][i]["ratingAmount"].int
                        let spotPk = json["result"][i]["spotpk"].int
                        let isLike = json["result"][i]["like"].bool
                        let spot:Spot = Spot(spotTitle: spotTitle!, category: category!, thumbnail: imageURLString!, address: address!, ratingStar: ratingStar!, ratingAmount: ratingAmount!, spotPk: spotPk!, isLike: isLike!)
                        self.spotItem.append(spot)
                        
                    }
                    print("spotItem: \(self.spotItem)")
                }else{
                    // 検索結果がない場合
                    self.noSearchTitle.isHidden = false
                    self.noSearchSubtitle.isHidden = false
                }
                
                break
            case .failure(let error):
                print(error)
                break
            }
            self.tableView.reloadData()
        }
    }

    
    func likeUpdate(isLike: Bool, spotId: String){
        var text = String()
        if isLike {
            // 登録
            text = Constants.likeURL + apiKey + Constants.spot + spotId + Constants.islike + "1" + Constants.lang + language
        }else{
            // 削除
            text = Constants.likeURL + apiKey + Constants.spot + spotId + Constants.islike + "0" + Constants.lang + language
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
    
    // 検索バーの設置
    func setSearchBar(){
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds{
            // NavigationBarに適したサイズの検索バーを設置
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "searchDestinationText".localized
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
        }
    }
    
    // 逆ギオコーディング処理
    func convert(lat: CLLocationDegrees, lon:CLLocationDegrees){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: language)) { (placeMark, error) in
            if let placeMark = placeMark{
                if let pm = placeMark.first{
                    if pm.administrativeArea != nil || pm.locality != nil{
                        self.locationQuery = pm.locality!
                        print("language: \(self.language)")
                        print("locationQuery: \(self.locationQuery)")
                    }else{
                        self.locationQuery = pm.name!
                    }
                }
            }
        }
        print("逆ジオコーデング")
    }
}

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        height.constant = CGFloat(Double(spotItem.count) * 150 + 43)
        
        cell.spotId = spotItem[indexPath.row].spotPk
        cell.spotTitle.text = spotItem[indexPath.row].spotTitle
        // textが枠内に入るようにする
        cell.spotTitle?.adjustsFontSizeToFitWidth = true
        cell.spotCategory.text = spotItem[indexPath.row].category
        cell.spotAddress.text = spotItem[indexPath.row].address
        cell.spotAddress?.adjustsFontSizeToFitWidth = true
        // Cosmos
        cell.ratingStar.settings.updateOnTouch = false
        cell.ratingStar.rating = Double(spotItem[indexPath.row].ratingStar)
        cell.ratingStar.settings.fillMode = .half
        cell.ratingNumber.text = String(spotItem[indexPath.row].ratingStar)
        cell.ratingAmount.text = String(spotItem[indexPath.row].ratingAmount)

        let profileImageURL = URL(string: self.spotItem[indexPath.row].thumbnail as String)
        //cell.spotImageView?.sd_setImage(with: profileImageURL, completed: nil)
        // 画像の高速化処理
        cell.spotImageView?.sd_setImage(with: profileImageURL, completed: { (image, error, _, _) in
            if error == nil{
                cell.setNeedsLayout()
            }
        })
        // like
        cell.delegate = self
        cell.index = indexPath
        if spotItem[indexPath.row].isLike{
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = ThemeColor.errorString
        }else{
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .lightGray
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルが選択された場合の処理
        spotId = spotItem[indexPath.row].spotPk
        // spotPkを渡す
        performSegue(withIdentifier: "spotdetail", sender: nil)
    }
}

extension HomeViewController: CellDelegate{
    
    func didTapButton(cell: CustomCell, index: IndexPath) {
        // Likeを消去した時の処理
        print(index.row)
        print("spotItem:\(spotItem)")
        let isLike = spotItem[index.row].isLike
        
        if isLike{
            // Likeの場合Likeを消去する
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .lightGray
            spotItem[index.row].isLike = false
            self.likeUpdate(isLike: false, spotId: String(cell.spotId!))
        }else{
            // Likeに追加する
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = ThemeColor.errorString
            spotItem[index.row].isLike = true
            self.likeUpdate(isLike: true, spotId: String(cell.spotId!))
        }
        
    }
}

// SearchBar
extension HomeViewController: UISearchBarDelegate{
    // 検索バーで入力する時
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    // 検索バーのキャンセルボタンタップ時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    // 検索バーでEnterが押された時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchQuery = searchBar.text{
            print("lets search")
            fetchData(query: searchQuery)
        }
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: CategoryListDelegate{
    
    func categoryData(key: String, label: String) {
        categoryButton.setTitle(label, for: .normal)
        categoryButton.setTitleColor(ThemeColor.firstString, for: .normal)
        categoryQuery = key
    }
    
    func defaultCategoryData(key: String, label: String) {
        categoryButton.setTitle(label, for: .normal)
        categoryButton.setTitleColor(.lightGray, for: .normal)
        categoryQuery = key
    }
}

extension HomeViewController: LocationListDelegate{
    
    func locationData(key: String, label: String) {
        locationButton.setTitle(label, for: .normal)
        locationButton.setTitleColor(ThemeColor.firstString, for: .normal)
        locationQuery = key
        
    }
    
    func defaultLocationData(key: String, label: String){
        locationButton.setTitle(label, for: .normal)
        locationButton.setTitleColor(.lightGray, for: .normal)
        locationQuery = key
    }
}

extension HomeViewController: CLLocationManagerDelegate{
    // 位置情報が更新されたときに位置情報を格納する
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager is called")
        let location = locations.last
        latitude = location?.coordinate.latitude
        longitude = location?.coordinate.longitude
        convert(lat: latitude!, lon: longitude!)
    }
}
