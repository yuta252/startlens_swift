//
//  PrivacyPolicyViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/28.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("contentHeight: \(contentText.frame.height)")
        contentHeight.constant = contentText.frame.height + 60
    }

    func setupUI(){
        contentTitle.text = "privacyPolicyTitle".localized
        contentText.text = "privacyPolicyContent".localized
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
