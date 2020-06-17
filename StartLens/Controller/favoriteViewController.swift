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
    
    var spotItem = [Spot]()
    var apiKey = String()
    
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        // TabaleView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
        
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(favoriteViewController.update), for: .valueChanged)
        
        fetchData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewwillapper is called")
        fetchData()
        tableView.reloadData()
    }
    
    // クエリによるデータの抽出
    func fetchData(){
        
        let url = Constants.favoriteURL + apiKey
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            print(response)
            switch response.result{
                
            case .success:
                let json:JSON = JSON(response.data as Any)
                if let num = json["info"]["num"].int, num != 0{
                    self.noFavoriteTItle.isHidden = true
                    self.noFavoriteSubtitle.isHidden = true
                    self.spotItem = []
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
                    self.spotItem = []
                    self.noFavoriteTItle.isHidden = false
                    self.noFavoriteSubtitle.isHidden = false
                }
                
                break
            case .failure(let error):
                print(error)
                break
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc func update(){
        fetchData()
        tableView.reloadData()
        refresh.endRefreshing()
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

extension favoriteViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // セルが選択された場合の処理
//        let indexNumber = indexPath.row
//        // spotPkを渡す
//
//    }
}

extension favoriteViewController: CellDelegate{
    
    func didTapButton(cell: CustomCell, index: IndexPath) {
        // Likeを消去した時の処理
        print(index.row)
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
