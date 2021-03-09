//
//  CategoryListViewController.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/24.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

protocol CategoryListDelegate {
    func categoryData(key: String, label: String)
    func defaultCategoryData(key: String, label: String)
}

class CategoryListViewController: UIViewController {

    @IBOutlet weak var mountainsButton: UIButton!
    @IBOutlet weak var plateauButton: UIButton!
    @IBOutlet weak var lakeButton: UIButton!
    @IBOutlet weak var riverButton: UIButton!
    @IBOutlet weak var waterfallButton: UIButton!
    @IBOutlet weak var coastButton: UIButton!
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var animalButton: UIButton!
    @IBOutlet weak var plantButton: UIButton!
    @IBOutlet weak var naturalPhenomenonButton: UIButton!
    @IBOutlet weak var historicSiteButton: UIButton!
    @IBOutlet weak var religiousBuildingButton: UIButton!
    @IBOutlet weak var castleButton: UIButton!
    @IBOutlet weak var villageButton: UIButton!
    @IBOutlet weak var townButton: UIButton!
    @IBOutlet weak var parkButton: UIButton!
    @IBOutlet weak var buildingButton: UIButton!
    @IBOutlet weak var annualEventButton: UIButton!
    @IBOutlet weak var zooButton: UIButton!
    @IBOutlet weak var meseumButton: UIButton!
    @IBOutlet weak var themeParkButton: UIButton!
    @IBOutlet weak var hotSpringButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: CategoryListDelegate?
    var categoryKey = String()
    var categoryLabel = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func selectedCategoryAction(_ sender: UIButton) {
        switch sender.tag{
        case 11:
            categoryKey = "11"
            categoryLabel = "mountains".localized
            break
        case 12:
            categoryKey = "12"
            categoryLabel = "plateau".localized
            break
        case 13:
            categoryKey = "13"
            categoryLabel = "lake".localized
            break
        case 14:
            categoryKey = "14"
            categoryLabel = "river".localized
            break
        case 15:
            categoryKey = "15"
            categoryLabel = "waterfall".localized
            break
        case 16:
            categoryKey = "16"
            categoryLabel = "coast".localized
            break
        case 17:
            categoryKey = "17"
            categoryLabel = "rock".localized
            break
        case 18:
            categoryKey = "18"
            categoryLabel = "animal".localized
            break
        case 19:
            categoryKey = "19"
            categoryLabel = "plant".localized
            break
        case 20:
            categoryKey = "20"
            categoryLabel = "naturalPhenomenon".localized
            break
        case 21:
            categoryKey = "21"
            categoryLabel = "historicSite".localized
            break
        case 22:
            categoryKey = "22"
            categoryLabel = "religiousBuilding".localized
            break
        case 23:
            categoryKey = "23"
            categoryLabel = "castle".localized
            break
        case 24:
            categoryKey = "24"
            categoryLabel = "village".localized
            break
        case 25:
            categoryKey = "25"
            categoryLabel = "localLandscape".localized
            break
        case 26:
            categoryKey = "26"
            categoryLabel = "park".localized
            break
        case 27:
            categoryKey = "27"
            categoryLabel = "building".localized
            break
        case 28:
            categoryKey = "28"
            categoryLabel = "annualEvent".localized
            break
        case 29:
            categoryKey = "29"
            categoryLabel = "zoo".localized
            break
        case 30:
            categoryKey = "30"
            categoryLabel = "museum".localized
            break
        case 31:
            categoryKey = "31"
            categoryLabel = "themePark".localized
            break
        case 32:
            categoryKey = "32"
            categoryLabel = "hotSpring".localized
            break
        case 33:
            categoryKey = "33"
            categoryLabel = "food".localized
            break
        case 34:
            categoryKey = "34"
            categoryLabel = "event".localized
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
    
    func setupUI() {
        mountainsButton.setTitle("mountains".localized, for: .normal)
        plateauButton.setTitle("plateau".localized, for: .normal)
        lakeButton.setTitle("lake".localized, for: .normal)
        riverButton.setTitle("river".localized, for: .normal)
        waterfallButton.setTitle("waterfall".localized, for: .normal)
        coastButton.setTitle("coast".localized, for: .normal)
        rockButton.setTitle("rock".localized, for: .normal)
        animalButton.setTitle("animal".localized, for: .normal)
        plantButton.setTitle("plant".localized, for: .normal)
        naturalPhenomenonButton.setTitle("naturalPhenomenon".localized, for: .normal)
        historicSiteButton.setTitle("historicSite".localized, for: .normal)
        religiousBuildingButton.setTitle("religiousBuilding".localized, for: .normal)
        castleButton.setTitle("castle".localized, for: .normal)
        villageButton.setTitle("village".localized, for: .normal)
        townButton.setTitle("localLandscape".localized, for: .normal)
        parkButton.setTitle("park".localized, for: .normal)
        buildingButton.setTitle("building".localized, for: .normal)
        annualEventButton.setTitle("annualEvent".localized, for: .normal)
        zooButton.setTitle("zoo".localized, for: .normal)
        meseumButton.setTitle("museum".localized, for: .normal)
        themeParkButton.setTitle("themePark".localized, for: .normal)
        hotSpringButton.setTitle("hotSpring".localized, for: .normal)
        foodButton.setTitle("food".localized, for: .normal)
        eventButton.setTitle("event".localized, for: .normal)
        
        deleteButton.setTitle("deleteButtonTitle".localized, for: .normal)
    }
}
