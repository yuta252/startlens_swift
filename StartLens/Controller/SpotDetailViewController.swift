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
    var spotId: Int = 1
    var spot: Spot?
    var exhibits = [Exhibit]()
    var exhibitId: Int?
    var exhibit: Exhibit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
            // Send variables to spotContentVC
            let spotContentVC = segue.destination as! SpotContentViewController
            spotContentVC.spot = self.spot
            break
        case "camera":
            let cameraVC = segue.destination as! CameraViewController
            cameraVC.spotId = self.spotId
            cameraVC.exhibits = self.exhibits
            break
        case "reviewPost":
            let reviewPostVC = segue.destination as! ReviewPostViewController
            reviewPostVC.spot = self.spot
            break
        case "reviewList":
            let reviewListVC = segue.destination as! ReviewListViewController
            reviewListVC.spot = self.spot
            break
        case "exhibitList":
            let exhibitListVC = segue.destination as! ExhibitListViewController
            exhibitListVC.exhibits = self.exhibits
            break
        case "exhibitDetail":
            let exhibitDetailVC = segue.destination as! ExhibitDetailViewController
            exhibitDetailVC.exhibit = self.exhibit
            break
        default:
            break
        }
    }
    
    func getContentHeight(height: CGFloat) {
        print("Action: getContentHeight, Message: delegate is called, content height: \(height)")
        contentViewHeight.constant = height
    }
    
    func moveToCamera(exhibits: [Exhibit]) {
        self.exhibits = exhibits
        performSegue(withIdentifier: "camera", sender: nil)
    }
    
    func moveToReviewPost() {
        performSegue(withIdentifier: "reviewPost", sender: nil)
    }
    
    func moveToReviewContinue() {
        performSegue(withIdentifier: "reviewList", sender: nil)
    }
    
    func  moveToExhibitContinue(exhibits: [Exhibit]) {
        self.exhibits = exhibits
        performSegue(withIdentifier: "exhibitList", sender: nil)
    }
    
    func moveToExhibitDetail(exhibit: Exhibit) {
        self.exhibit = exhibit
        performSegue(withIdentifier: "exhibitDetail", sender: nil)
    }
}
