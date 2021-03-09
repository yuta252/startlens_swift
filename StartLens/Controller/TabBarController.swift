//
//  TabBarController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/25.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}
