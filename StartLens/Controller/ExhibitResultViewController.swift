//
//  ExhibitResultViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/19.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import SDWebImage

class ExhibitResultViewController: UIViewController {

    var spotId: Int?
    var exhibitItem = [Exhibit]()
    var apiKey = String()
    var exhibitObj: Exhibit?
    
    
    @IBOutlet weak var predictionTitle: UILabel!
    @IBOutlet weak var exhibitNum: UILabel!
    @IBOutlet weak var exhibitResultCollectionView: UICollectionView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初期設定
        apiKey = UserDefaults.standard.string(forKey: "apiKey")!
        
        setupUI()
        exhibitResultCollectionView.dataSource = self
        exhibitResultCollectionView.delegate = self
        exhibitResultCollectionView.register(UINib(nibName: "RecommendCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        exhibitResultCollectionView.reloadData()
        
        exhibitNum.text = "(" + String(exhibitItem.count) + "exhibitResultItem".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.contentHeight.constant = self.exhibitResultCollectionView.contentSize.height
    }

    @IBAction func backAction(_ sender: Any) {
        print("tapped")
        self.dismiss(animated: true, completion: nil)
    }
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "exhibitDetail":
            let exhibitDetailVC = segue.destination as! ExhibitDetailViewController
            exhibitDetailVC.spotId = spotId
            exhibitDetailVC.exhibitObj = exhibitObj
            break
        default:
            break
        }
    }
    
    func setupUI(){
        predictionTitle.text = "exhibitResultText".localized
    }
}

        
extension ExhibitResultViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibitItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("exhibitItem: \(exhibitItem)")
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

extension ExhibitResultViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellWidth:CGFloat = (self.view.bounds.width - horizontalSpace - 40)/2
        print("collectionview is called: \(cellWidth)")
        let cellHeight:CGFloat = cellWidth + 50
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

