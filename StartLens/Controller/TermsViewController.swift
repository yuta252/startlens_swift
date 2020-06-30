//
//  TermsViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/28.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var termsTitle: UILabel!
    @IBOutlet weak var termsContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
   
    override func viewDidAppear(_ animated: Bool) {
       contentHeight.constant = termsContent.frame.height + 60
    }

    func setupUI(){
       termsTitle.text = "termsTitle".localized
       termsContent.text = "termsContent".localized
    }

    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
