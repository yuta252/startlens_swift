//
//  favoriteViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/26.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class favoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavoriteTItle: UILabel!
    @IBOutlet weak var noFavoriteSubtitle: UILabel!
    
    var token = String()
    var language = String()
    var spots = [Spot]()
    var spotId: Int?
    
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
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(favoriteViewController.update), for: .valueChanged)
        
        // Data settings
        // fetchData()
        // tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // To be considerd: whether fetchData is called in viewDidLoad or viewDidAppear
        fetchData()
        tableView.reloadData()
    }
    
    func fetchData() {
        let headers: HTTPHeaders = ["Authorization": token, "Content-Type": "application/json"]
        let url = Constants.baseURL + Constants.favoriteURL
        print("favoriteurl: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            switch response.result {
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("json: \(json)")
                self.spots = try! JSONDecoder().decode([Spot].self, from: response.data!)
                
                if self.spots.count != 0 {
                    self.noFavoriteTItle.isHidden = true
                    self.noFavoriteSubtitle.isHidden = true
                } else {
                    self.noFavoriteTItle.isHidden = false
                    self.noFavoriteSubtitle.isHidden = false
                }
            case .failure(let error):
                print(error)
                break
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func update() {
        fetchData()
        tableView.reloadData()
        refresh.endRefreshing()
    }
    
    func setupUI(){
        noFavoriteTItle.text = "noFavoriteText".localized
        noFavoriteSubtitle.text = "noFavoriteHelp".localized
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier{
        case "spotContent":
            let spotDetailVC = segue.destination as! SpotDetailViewController
            // spotDetailVC.spotId = spotId
        default:
            break
        }
        
    }
}

extension favoriteViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.spotId = self.spots[indexPath.row].id
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
        }
        return cell
    }
    
}

extension favoriteViewController: UITableViewDelegate{
    
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

extension favoriteViewController: CellDelegate{
    func didTapButton(cell: CustomCell, index: IndexPath) {
        // TODO: Favarite
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
