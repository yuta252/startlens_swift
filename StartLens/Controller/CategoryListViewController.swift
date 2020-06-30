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

    
    @IBOutlet weak var natureButton: UIButton!
    @IBOutlet weak var historicButton: UIButton!
    @IBOutlet weak var religiousButton: UIButton!
    @IBOutlet weak var castleButton: UIButton!
    @IBOutlet weak var townButton: UIButton!
    @IBOutlet weak var parkButton: UIButton!
    @IBOutlet weak var annualEventButton: UIButton!
    @IBOutlet weak var buildingButton: UIButton!
    @IBOutlet weak var zooButton: UIButton!
    @IBOutlet weak var museumButton: UIButton!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var springButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var delegate: CategoryListDelegate?
    var categoryKey = String()
    var categoryLabel = String()
    var language = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    @IBAction func selectedCategoryAction(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            categoryKey = "0"
            categoryLabel = "categoryNature".localized
            break
        case 1:
            categoryKey = "1"
            categoryLabel = "categoryHistoric".localized
            break
        case 2:
            categoryKey = "2"
            categoryLabel = "categoryReligion".localized
            break
        case 3:
            categoryKey = "3"
            categoryLabel = "categoryCastle".localized
            break
        case 4:
            categoryKey = "4"
            categoryLabel = "categoryLocal".localized
            break
        case 5:
            categoryKey = "5"
            categoryLabel = "categoryPark".localized
            break
        case 6:
            categoryKey = "6"
            categoryLabel = "categoryBuilding".localized
            break
        case 7:
            categoryKey = "7"
            categoryLabel = "categoryAnnual".localized
            break
        case 8:
            categoryKey = "8"
            categoryLabel = "categoryZoo".localized
            break
        case 9:
            categoryKey = "9"
            categoryLabel = "categoryMuseum".localized
            break
        case 10:
            categoryKey = "10"
            categoryLabel = "categoryTheme".localized
            break
        case 11:
            categoryKey = "11"
            categoryLabel = "categorySpring".localized
            break
        case 12:
            categoryKey = "12"
            categoryLabel = "categoryFood".localized
            break
        case 13:
            categoryKey = "13"
            categoryLabel = "categoryEvent".localized
            break
        default:
            categoryKey = "all"
            categoryLabel = "searchCategoryPlace".localized
        }
        
        
        self.delegate?.categoryData(key: categoryKey, label: categoryLabel)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        categoryKey = "all"
        categoryLabel = "searchCategoryPlace".localized
        self.delegate?.defaultCategoryData(key: categoryKey, label: categoryLabel)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        natureButton.setTitle("categoryNature".localized, for: .normal)
        historicButton.setTitle("categoryHistoric".localized, for: .normal)
        religiousButton.setTitle("categoryReligion".localized, for: .normal)
        castleButton.setTitle("categoryCastle".localized, for: .normal)
        townButton.setTitle("categoryLocal".localized, for: .normal)
        parkButton.setTitle("categoryPark".localized, for: .normal)
        annualEventButton.setTitle("categoryAnnual".localized, for: .normal)
        buildingButton.setTitle("categoryBuilding".localized, for: .normal)
        zooButton.setTitle("categoryZoo".localized, for: .normal)
        museumButton.setTitle("categoryMuseum".localized, for: .normal)
        themeButton.setTitle("categoryTheme".localized, for: .normal)
        springButton.setTitle("categorySpring".localized, for: .normal)
        foodButton.setTitle("categoryFood".localized, for: .normal)
        eventButton.setTitle("categoryEvent".localized, for: .normal)
        deleteButton.setTitle("deleteButtonTitle".localized, for: .normal)
    }

}
