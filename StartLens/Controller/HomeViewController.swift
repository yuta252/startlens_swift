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
    
    var token = String()
    var pagedSpot: PagedSpot?
    var spots = [Spot]()
    var spotId: Int?
    var language = String()
    var searchBar: UISearchBar!
    var searchQuery: String = "all"
    var locationQuery: String = "all"
    var categoryQuery: String = "all"
    var parameters = [String: String]()
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial settings
        language = Language.getLanguage()
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else{
            // if cannot get a token, move to login screen
            print("Error: No token")
            return
        }
        token = savedToken
        
        // UI settings
        setupUI()
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
        // Set search bar in navigation bar
        setSearchBar()
        
        // Data settings
        // fetchData(params: ["items": "3"])
        // tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // To be considerd: whether fetchData is called in viewDidLoad or viewDidAppear
        self.parameters = createParameters()
        fetchData(params: self.parameters)
        tableView.reloadData()
    }
    
    func setupUI() {
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
    
    @IBAction func locationSearchAction(_ sender: Any) {
        performSegue(withIdentifier: "location", sender: nil)
    }
    
    @IBAction func categorySearchAction(_ sender: Any) {
        performSegue(withIdentifier: "category", sender: nil)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        self.parameters = createParameters()
        fetchData(params: self.parameters)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "category":
            let categoryVC = segue.destination as! CategoryListViewController
            categoryVC.delegate = self
            break
        case "location":
            let locationVC = segue.destination as! LocationViewController
            locationVC.delegate = self
            break
//        case "spotdetail":
//            let spotDetailVC = segue.destination as! SpotDetailViewController
//            spotDetailVC.spotId = spotId
        default:
            break
        }
    }
    
    func fetchData(params: [String: String]) {
        /**
         - Parameters: params: dictionary of parameters
            items: Int
                The number of fetching spot
            query: String
                Free word to search spot name
            category: Int
                Spot category
            prefecture: String
                Address of spot
         */
        let headers: HTTPHeaders = ["Authorization": token, "Content-Type": "application/json"]
        let url = Constants.baseURL + Constants.spotURL
        let urlWithParams = createURLWithParameters(url: url, params: params)
        let encodedUrl = urlWithParams.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(encodedUrl)")
        AF.request(encodedUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("json: \(json)")
                self.pagedSpot = try? JSONDecoder().decode(PagedSpot.self, from: response.data!)
                print("pagedSpot: \(self.pagedSpot)")
                self.spots = []
                if let num = self.pagedSpot?.data.count, num != 0 {
                    self.spots = self.pagedSpot!.data
                    self.noSearchTitle.isHidden = true
                    self.noSearchSubtitle.isHidden = true
                } else {
                    self.noSearchTitle.isHidden = false
                    self.noSearchSubtitle.isHidden = false
                }
            case .failure(let error):
                print(error)
                break
            }
            self.tableView.reloadData()
        }
    }
    
    func createParameters() -> [String: String] {
        /**
         - Returns: dictionary of query parameters
        */
        // if all is selected, skip the query
        var parameters = [String: String]()
        if searchQuery != "all" {
            parameters["query"] = searchQuery
        }
        if locationQuery != "all" {
            parameters["prefecture"] = locationQuery
        }
        if categoryQuery != "all" {
            parameters["category"] = categoryQuery
        }
        // if any parameters is not set, set items query
        if parameters.isEmpty {
            parameters["items"] = "20"
            return parameters
        }
        return parameters
    }
    
    func createURLWithParameters(url: String, params: [String: String]) -> String {
        /**
         Create request url with parameters
         - Parameters
            url: http://startlens.jp/api/v1/tourist/spots
            params: dictionary of parameters
             items: The number of fetching spot
             query: Free word to search spot name
             category: Spot category
             prefecture: Address of spot
         */
        var urlWithParams = url
        var isQuestion = true
        
        for (key, value) in params {
            if (isQuestion) {
                urlWithParams = urlWithParams + "?" + key + "=" + value
                isQuestion = false
            } else {
                urlWithParams = urlWithParams + "&" + key + "=" + value
            }
        }
        return urlWithParams
    }
    
    func setSearchBar() {
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            // Set search bar
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "searchDestinationText".localized
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            // Remove back button
            navigationItem.hidesBackButton = true
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView count: \(self.spots.count)")
        return self.spots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        height.constant = CGFloat(Double(self.spots.count) * 150 + 43)
        
        cell.spotId = self.spots[indexPath.row].id
        // TODO: 言語ごとに切り替える
        cell.spotTitle.text = self.spots[indexPath.row].multiProfiles[0].username
        cell.spotTitle?.adjustsFontSizeToFitWidth = true
        cell.spotCategory.text = Constants.majorCategoryMap[self.spots[indexPath.row].profile.majorCategory]
        cell.spotAddress.text = self.spots[indexPath.row].multiProfiles[0].addressPrefecture + self.spots[indexPath.row].multiProfiles[0].addressCity + self.spots[indexPath.row].multiProfiles[0].addressStreet
        cell.spotAddress?.adjustsFontSizeToFitWidth = true
        // Cosmos
        cell.ratingStar.settings.updateOnTouch = false
        cell.ratingStar.rating = Double(self.spots[indexPath.row].profile.rating)
        cell.ratingStar.settings.fillMode = .half
        cell.ratingNumber.text = String(self.spots[indexPath.row].profile.rating)
        cell.ratingAmount.text = String(self.spots[indexPath.row].profile.ratingCount)

        let profileImageURL = URL(string: self.spots[indexPath.row].profile.url)
        // Acceleration processing of image
        cell.spotImageView?.sd_setImage(with: profileImageURL, completed: { (image, error, _, _) in
            if error == nil{
                cell.setNeedsLayout()
            }
        })
        // like
        cell.delegate = self
        cell.index = indexPath
        if self.spots[indexPath.row].isFavorite {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = ThemeColor.errorString
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .lightGray
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spotDetailVC = self.storyboard?.instantiateViewController(identifier: "spotDetail") as! SpotDetailViewController
        spotDetailVC.spot = self.spots[indexPath.row]
        self.navigationController?.pushViewController(spotDetailVC, animated: true)
    }
}

extension HomeViewController: CellDelegate {
    func didTapButton(cell: CustomCell, index: IndexPath) {
        print(index.row)
        let isFavorite = self.spots[index.row].isFavorite
        
        if isFavorite {
            // Remove like if has already been favorite
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .lightGray
            self.spots[index.row].removeFavorite(token: self.token, spotId: cell.spotId!)
        } else {
            // Add like if has never been favorite
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = ThemeColor.errorString
            self.spots[index.row].addFavorite(token: self.token, spotId: cell.spotId!)
        }
    }
}

// SearchBar
extension HomeViewController: UISearchBarDelegate {
    // When search bar is inputed
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    // Cancel button in search bar is tapped
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    // Enter button in search bar is tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            print("Action: searchBarSearchButtonClicked, Message: Start to search with \(searchQuery)")
            self.searchQuery = query
            self.parameters = createParameters()
            fetchData(params: self.parameters)
        }
        // Reset search bar query
        self.searchQuery = "all"
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: CategoryListDelegate {
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

extension HomeViewController: LocationListDelegate {
    func locationData(key: String, label: String) {
        locationButton.setTitle(label, for: .normal)
        locationButton.setTitleColor(ThemeColor.firstString, for: .normal)
        locationQuery = key
        
    }
    
    func defaultLocationData(key: String, label: String) {
        locationButton.setTitle(label, for: .normal)
        locationButton.setTitleColor(.lightGray, for: .normal)
        locationQuery = key
    }
}
