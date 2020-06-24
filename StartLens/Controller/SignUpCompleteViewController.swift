//
//  SignUpCompleteViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/12.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Alamofire

class SignUpCompleteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var womanTextField: UIButton!
    @IBOutlet weak var manTextField: UIButton!
    @IBOutlet weak var noAnswerTextField: UIButton!
    @IBOutlet weak var yearTextField: UITextField!
    
    var emailAddress = String()
    var apiKey = String()
    var sex: Int = 0
    var year: Int = 0
    
    var pickerView: UIPickerView = UIPickerView()
    let list = ["1941", "1942", "1943", "1944", "1945", "1946", "1947", "1948", "1949", "1950", "1951", "1952", "1953", "1954", "1955", "1956", "1957", "1958", "1959", "1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 入力欄
        pickerView.delegate = self
        pickerView.dataSource = self

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        // OKボタン
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        doneButton.setBackgroundImage(UIImage(systemName: "checkmark"), for: UIControl.State())
        doneButton.addTarget(self, action: #selector(SignUpCompleteViewController.done), for: .touchUpInside)
        let doneButtomItem = UIBarButtonItem(customView: doneButton)
        // キャンセルボタン
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        cancelButton.setBackgroundImage(UIImage(systemName: "xmark"), for: UIControl.State())
        cancelButton.addTarget(self, action: #selector(SignUpCompleteViewController.cancel), for: .touchUpInside)
        let cancelButtomItem = UIBarButtonItem(customView: cancelButton)
        // 余白（スペーサー）
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButtomItem, flexibleItem, doneButtomItem], animated: true)
        
        self.yearTextField.inputView = pickerView
        self.yearTextField.inputAccessoryView = toolbar
        
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sexSelect(_ sender: Any) {
        
        if let button = sender as? UIButton{
            let tag:Int = button.tag
            print("\(tag) is pushed")
            
            switch (tag){
            case 1:
                // 女性の場合
                sex = 1
                womanTextField.backgroundColor = ThemeColor.main
                womanTextField.setTitleColor(UIColor.white, for: .normal)
                manTextField.backgroundColor = ThemeColor.secondString
                manTextField.setTitleColor(ThemeColor.firstString, for: .normal)
                noAnswerTextField.backgroundColor = ThemeColor.secondString
                noAnswerTextField.setTitleColor(ThemeColor.firstString, for: .normal)
            case 2:
                // 男性の場合
                sex = 2
                womanTextField.backgroundColor = ThemeColor.secondString
                womanTextField.setTitleColor(ThemeColor.firstString, for: .normal)
                manTextField.backgroundColor = ThemeColor.main
                manTextField.setTitleColor(UIColor.white, for: .normal)
                noAnswerTextField.backgroundColor = ThemeColor.secondString
                noAnswerTextField.setTitleColor(ThemeColor.firstString, for: .normal)
            case 3:
                // 無回答の場合
                sex = 3
                womanTextField.backgroundColor = ThemeColor.secondString
                womanTextField.setTitleColor(ThemeColor.firstString, for: .normal)
                manTextField.backgroundColor = ThemeColor.secondString
                manTextField.setTitleColor(ThemeColor.firstString, for: .normal)
                noAnswerTextField.backgroundColor = ThemeColor.main
                noAnswerTextField.setTitleColor(UIColor.white, for: .normal)
            default:
                sex = 0
            }
        }
    }
    
    @IBAction func completeAction(_ sender: Any) {
        let parameters = ["answer":["apikey": apiKey, "sex": sex,"year": year]]
        // アンケートの送信
        AF.request(Constants.QuestionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response)
            
            switch response.result{
            
            case .success:
                self.performSegue(withIdentifier: "home", sender: nil)

            case .failure(let error):
                print(error)
            }
        }
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[49]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.year = Int(list[row])!
        self.yearTextField.text = list[row]
    }
    
    @objc func cancel(){
        self.yearTextField.text = ""
        self.yearTextField.endEditing(true)
    }
    
    @objc func done(){
        self.yearTextField.endEditing(true)
    }
    
}
