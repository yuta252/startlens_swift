//
//  SignUpCompleteViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/12.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire

class SignUpCompleteViewController: UIViewController {

    @IBOutlet weak var completeTitleText: UILabel!
    @IBOutlet weak var completeSubTitleText: UILabel!
    @IBOutlet weak var sexTitleText: UILabel!
    @IBOutlet weak var womanTextField: UIButton!
    @IBOutlet weak var manTextField: UIButton!
    @IBOutlet weak var noAnswerTextField: UIButton!
    @IBOutlet weak var sexHelpText: UILabel!
    @IBOutlet weak var birthTitleText: UILabel!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var birthHelpText: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var sex: Int = 0
    var year: Int = 0
    var country = String()
    var language = String()
    var toolbar: UIToolbar?
    var token = String()
    var id = Int()
    
    var pickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let savedToken = UserDefaults.standard.string(forKey: "token") else {
            let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as! SignUpViewController
            present(signUpViewController, animated: true, completion: nil)
            return
        }
        
        token = savedToken
        id = UserDefaults.standard.integer(forKey: "id")

        pickerView.delegate = self
        pickerView.dataSource = self

        setupUI()
        setupToolBar()
        
        yearTextField.inputView = pickerView
        yearTextField.inputAccessoryView = toolbar
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sexSelect(_ sender: Any) {
        if let button = sender as? UIButton{
            let tag:Int = button.tag
            print("\(tag) is pushed")
            switch (tag){
            case 1:
                sex = 1
                resetSexSelectButton()
                setSexSelectButton(textField: womanTextField)
            case 2:
                sex = 2
                resetSexSelectButton()
                setSexSelectButton(textField: manTextField)
            case 3:
                sex = 3
                resetSexSelectButton()
                setSexSelectButton(textField: noAnswerTextField)
            default:
                sex = 0
                resetSexSelectButton()
            }
        }
    }
    
    @IBAction func completeAction(_ sender: Any) {
        let url = Constants.baseURL + Constants.touristsURL + "/" + String(id)
        print("url: \(url)")
        let parameters = ["tourist":["username": "Anonymous", "sex": sex,"birth": year, "country": country, "lang": language]]
        print("parameters: \(parameters)")
        let headers: HTTPHeaders = ["Content-Type": "application/json", "Authorization": token]

        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            
            switch response.result {
            case .success:
                print("moved to home VC")
//                let homeVC = self.storyboard?.instantiateViewController(identifier: "home") as! HomeViewController
//                self.navigationController?.pushViewController(homeVC, animated: true)
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: "homeTabBar") as! TabBarController
                self.navigationController?.pushViewController(tabBarVC, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupUI() {
        completeTitleText.text = "signupCompleteText".localized
        completeSubTitleText.text = "signupCompleteSubText".localized
        sexTitleText.text = "sexTitleText".localized
        womanTextField.setTitle("sexFemaleText".localized, for: .normal)
        manTextField.setTitle("sexMaleText".localized, for: .normal)
        noAnswerTextField.setTitle("sexNAText".localized, for: .normal)
        sexHelpText.text = "sexHelpText".localized
        birthTitleText.text = "birthTitleText".localized
        birthHelpText.text = "birthHelpText".localized
        completeButton.setTitle("signupCompleteButton".localized, for: .normal)
    }
    
    func setupToolBar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        // OK button
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        doneButton.setBackgroundImage(UIImage(systemName: "checkmark"), for: UIControl.State())
        doneButton.addTarget(self, action: #selector(SignUpCompleteViewController.done), for: .touchUpInside)
        let doneButtomItem = UIBarButtonItem(customView: doneButton)
        // Cancel button
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        cancelButton.setBackgroundImage(UIImage(systemName: "xmark"), for: UIControl.State())
        cancelButton.addTarget(self, action: #selector(SignUpCompleteViewController.cancel), for: .touchUpInside)
        let cancelButtomItem = UIBarButtonItem(customView: cancelButton)
        // Spacer
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar!.setItems([cancelButtomItem, flexibleItem, doneButtomItem], animated: true)
    }
    
    @objc func cancel(){
        self.yearTextField.text = ""
        self.yearTextField.endEditing(true)
    }
    
    @objc func done(){
        self.yearTextField.endEditing(true)
    }
    
    func setSexSelectButton(textField: UIButton) {
        textField.backgroundColor = ThemeColor.main
        textField.setTitleColor(UIColor.white, for: .normal)
    }

    func resetSexSelectButton() {
        womanTextField.backgroundColor = ThemeColor.secondString
        womanTextField.setTitleColor(ThemeColor.firstString, for: .normal)
        manTextField.backgroundColor = ThemeColor.secondString
        manTextField.setTitleColor(ThemeColor.firstString, for: .normal)
        noAnswerTextField.backgroundColor = ThemeColor.secondString
        noAnswerTextField.setTitleColor(ThemeColor.firstString, for: .normal)
    }
}

extension SignUpCompleteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Number of row of UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of list in UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.yearList.count
    }
    
    // Default display of UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("list49: \(Constants.yearList[row])")
        return Constants.yearList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.year = Int(Constants.yearList[row])!
        self.yearTextField.text = Constants.yearList[row]
    }
}
