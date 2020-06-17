//
//  CategoryListViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/24.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

protocol CategoryListDelegate{
    func categoryData(key: String, label: String)
    func defaultCategoryData(key: String, label: String)
}

class CategoryListViewController: UIViewController {

    var delegate: CategoryListDelegate?
    var categoryKey = String()
    var categoryLabel = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func selectedCategoryAction(_ sender: UIButton) {
        print("selected")
        print(sender.tag)
        switch sender.tag{
        case 0:
            categoryKey = "0"
            categoryLabel = "自然"
            break
        case 1:
            categoryKey = "1"
            categoryLabel = "史跡"
            break
        case 2:
            categoryKey = "2"
            categoryLabel = "神社・寺院・教会"
            break
        case 3:
            categoryKey = "3"
            categoryLabel = "城跡・宮殿"
            break
        case 4:
            categoryKey = "4"
            categoryLabel = "街・郷土景観"
            break
        case 5:
            categoryKey = "5"
            categoryLabel = "庭園・公園"
            break
        case 6:
            categoryKey = "6"
            categoryLabel = "建造物"
            break
        case 7:
            categoryKey = "7"
            categoryLabel = "行事"
            break
        case 8:
            categoryKey = "8"
            categoryLabel = "動植物園・水族館"
            break
        case 9:
            categoryKey = "9"
            categoryLabel = "博物館・美術館"
            break
        case 10:
            categoryKey = "10"
            categoryLabel = "テーマ施設"
            break
        case 11:
            categoryKey = "11"
            categoryLabel = "温泉"
            break
        case 12:
            categoryKey = "12"
            categoryLabel = "食"
            break
        case 13:
            categoryKey = "13"
            categoryLabel = "イベント"
            break
        default:
            categoryKey = "all"
            categoryLabel = "カテゴリー"
        }
        
        self.delegate?.categoryData(key: categoryKey, label: categoryLabel)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        categoryKey = "all"
        categoryLabel = "カテゴリー"
        self.delegate?.defaultCategoryData(key: categoryKey, label: categoryLabel)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
