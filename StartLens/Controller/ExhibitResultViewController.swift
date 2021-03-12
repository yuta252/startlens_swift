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

    // var spotId: Int?
    var exhibits = [Exhibit]()
    var apiKey = String()
    var exhibit: Exhibit?
    
    @IBOutlet weak var predictionTitle: UILabel!
    @IBOutlet weak var exhibitNum: UILabel!
    @IBOutlet weak var exhibitResultCollectionView: UICollectionView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial settings
        
        // UI settings
        setupUI()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.contentHeight.constant = self.exhibitResultCollectionView.contentSize.height
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "exhibitDetail":
            let exhibitDetailVC = segue.destination as! ExhibitDetailViewController
            // exhibitDetailVC.spotId = spotId
            exhibitDetailVC.exhibit = self.exhibit
            break
        default:
            break
        }
    }
    
    func setupUI() {
        exhibitNum.text = "(" + String(exhibits.count) + "exhibitResultItem".localized
        predictionTitle.text = "exhibitResultText".localized
    }
    
    func setupCollectionView() {
        exhibitResultCollectionView.dataSource = self
        exhibitResultCollectionView.delegate = self
        exhibitResultCollectionView.register(UINib(nibName: "RecommendCell", bundle: nil), forCellWithReuseIdentifier: "RecommendCell")
        exhibitResultCollectionView.reloadData()
    }
}

        
extension ExhibitResultViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Action: cellForItemAt, exhibit: \(exhibits[indexPath.row])")
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
        //exhibitId = exhibitItem[indexPath.row].exhibitId
        self.exhibit = exhibits[indexPath.row]
        performSegue(withIdentifier: "exhibitDetail", sender: nil)
    }
}

extension ExhibitResultViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellWidth:CGFloat = (self.view.bounds.width - horizontalSpace - 40)/2
        print("Action: collectionViewLayout, cellWidth: \(cellWidth)")
        let cellHeight:CGFloat = cellWidth + 50
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

