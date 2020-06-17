//
//  NoSearchViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/26.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class NoSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func noSearchBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
