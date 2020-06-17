//
//  SpotDetailViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/26.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import SDWebImage

class SpotDetailViewController: UIViewController, SpotDetailDelegate {
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var spotContentViewController: SpotContentViewController?
    var spotId: Int?
    var exhibitId: Int?
    var exhibitObj: Exhibit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //height.constant = 1800
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spotContentViewController = (children[0] as! SpotContentViewController)
        spotContentViewController?.delegate = self
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
        case "spotcontent":
            let spotContentVC = segue.destination as! SpotContentViewController
            spotContentVC.spotId = spotId
            break
        case "reviewPost":
            let reviewPostVC = segue.destination as! ReviewPostViewController
            reviewPostVC.spotId = spotId
            break
        case "reviewList":
            let reviewListVC = segue.destination as! ReviewListViewController
            reviewListVC.spotId = spotId
            break
        case "exhibitList":
            let exhibitListVC = segue.destination as! ExhibitListViewController
            exhibitListVC.spotId = spotId
            break
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
    
    func getContentHeight(height: CGFloat) {
        print("delegate is called.ContentHeiht: \(height)")
        contentViewHeight.constant = height
    }
    
    func moveToCamera() {
        print("move to camera")
    }
    
    func moveToReviewPost() {
        performSegue(withIdentifier: "reviewPost", sender: nil)
    }
    
    func moveToReviewContinue() {
        performSegue(withIdentifier: "reviewList", sender: nil)
    }
    
    func  moveToExhibitContinue(){
        performSegue(withIdentifier: "exhibitList", sender: nil)
    }
    
//    func moveToExhibitDetail(id: Int) {
//        exhibitId = id
//        performSegue(withIdentifier: "exhibitDetail", sender: nil)
//    }
    
    func moveToExhibitDetail(Obj: Exhibit) {
        exhibitObj = Obj
        performSegue(withIdentifier: "exhibitDetail", sender: nil)
    }
}
