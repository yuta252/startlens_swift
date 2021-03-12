//
//  ExhibitDetailViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/15.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON


class ExhibitDetailViewController: UIViewController {

    @IBOutlet weak var exhibitImageView: UIImageView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var exhibitNameView: UILabel!
    @IBOutlet weak var exhibitIntroView: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    var exhibit: Exhibit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial settings
        
        // UI settings
        setupUI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        contentsView.layer.cornerRadius = 10.0
        contentsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let exhibitImageURL = URL(string: exhibit!.pictures[0].url)
        exhibitImageView?.sd_setImage(with: exhibitImageURL, completed: { (image, error, _, _) in
             if error == nil{
                self.exhibitImageView.setNeedsLayout()
             }
         })
        exhibitNameView.text = exhibit!.multiExhibits[0].name
        exhibitIntroView.text = exhibit!.multiExhibits[0].description
    }
}
