//
//  ExhibitListViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/15.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ExhibitListViewController: UIViewController {
    
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var noExhibit: UILabel!
    @IBOutlet weak var collectionIViewHeight: NSLayoutConstraint!
    
    var apiKey = String()
    var spotId: Int?
    var exhibitItem = [Exhibit]()
    //var exhibitId: Int?
    var exhibitObj: Exhibit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.register(UINib(nibName: "RecommendCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        
        fetchData()
        recommendCollectionView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "exhibitDetail":
            let exhibitDetailVC = segue.destination as! ExhibitDetailViewController
            exhibitDetailVC.spotId = spotId
            // exhibitDetailVC.exhibitId = exhibitId
            exhibitDetailVC.exhibitObj = exhibitObj
            break
        default:
            break
        }
    }
    
    func fetchData(){
        let text = Constants.exhibitListURL + apiKey + Constants.spot + String(spotId!)
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("url: \(url)")
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ (response) in
            
            print(response)
            switch response.result{
                
            case .success:
                let json:JSON = JSON(response.data as Any)
                
                // レコメンドデータのParse
                if let num = json["info"]["exhibitNum"].int, num != 0{
                    self.noExhibit.isHidden = true
                    self.exhibitItem = []
                    let roopNum = num - 1

                    for i in 0...roopNum{
                        let exhibitId = json["result"]["recommend"][i]["exhibitId"].int
                        let exhibitName = json["result"]["recommend"][i]["exhibitName"].string
                        let exhibitUrl = json["result"]["recommend"][i]["exhibitUrl"].string
                        print("exhibitName: \(exhibitName!), exhibitUrl: \(exhibitUrl!)")
                        let exhibit: Exhibit = Exhibit(exhibitId: exhibitId!, exhibitName: exhibitName!, exhibitImage: exhibitUrl!, exhibitIntro: "like")
                        self.exhibitItem.append(exhibit)
                    }
                    print("exhibitItem: \(self.exhibitItem)")
                }else{
                    // 検索結果がない場合
                    self.noExhibit.isHidden = false
                }

                break
            case .failure(let error):
                print(error)
                break
            }
            self.recommendCollectionView.reloadData()
            // 画像読み込み後再度高さ設定
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.collectionIViewHeight.constant = self.recommendCollectionView.contentSize.height
            }
            
        }
    }

}

extension ExhibitListViewController:UICollectionViewDataSource{
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
        //exhibitId = exhibitItem[indexPath.row].exhibitId
        exhibitObj = exhibitItem[indexPath.row]
        performSegue(withIdentifier: "exhibitDetail", sender: nil)
    }
}

extension ExhibitListViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellWidth:CGFloat = (self.view.bounds.width - horizontalSpace - 40)/2
        print("collectionview is called: \(cellWidth)")
        let cellHeight:CGFloat = cellWidth + 50
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
