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
    
    @IBOutlet weak var recommendTitleText: UILabel!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var noExhibit: UILabel!
    @IBOutlet weak var collectionIViewHeight: NSLayoutConstraint!
    
    var token = String()
    var spotId: Int?
    var language = String()
    var exhibits = [Exhibit]()
    var exhibit: Exhibit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
        // fetchData()
        recommendCollectionView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "exhibitDetail":
            let exhibitDetailVC = segue.destination as! ExhibitDetailViewController
            exhibitDetailVC.exhibit = self.exhibit
            break
        default:
            break
        }
    }
    
    func setupUI() {
        if self.exhibits.count != 0 {
            self.noExhibit.isHidden = true
        } else {
            // No exhibit data
            self.noExhibit.isHidden = false
        }
        recommendTitleText.text = "recommendTitleText".localized
        noExhibit.text = "noRecommendText".localized
    }
    
    func setupCollectionView() {
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        recommendCollectionView.register(UINib(nibName: "RecommendCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        recommendCollectionView.isScrollEnabled = false
    }
}

extension ExhibitListViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Action: numberOfItemsInSection, exhibits count: \(exhibits.count)")
        return exhibits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Action: CellForItemAt, Message: cellForItemAt is called")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as! RecommendCell
        // TODO: 多言語対応
        cell.exhibitName.text = exhibits[indexPath.row].multiExhibits[0].name
        let exhibitImageURL = URL(string: self.exhibits[indexPath.row].pictures[0].url)
        cell.exhibitImageView?.sd_setImage(with: exhibitImageURL, completed: { (image, error, _, _) in
            if error == nil{
                cell.setNeedsLayout()
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.exhibit = exhibits[indexPath.row]
        performSegue(withIdentifier: "exhibitDetail", sender: nil)
    }
}

extension ExhibitListViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellWidth:CGFloat = (self.view.bounds.width - horizontalSpace - 40)/2
        print("Action: UICollectionViewLayout, cellWidth: \(cellWidth)")
        let cellHeight:CGFloat = cellWidth + 50
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
