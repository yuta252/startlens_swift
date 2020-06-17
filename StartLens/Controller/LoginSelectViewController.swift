//
//  LoginSelectViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/09.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class LoginSelectViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        performSegue(withIdentifier: "logIn", sender: nil)
    }
    
}
