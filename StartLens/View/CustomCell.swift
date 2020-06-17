//
//  CustomCell.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/05/23.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Cosmos

protocol CellDelegate: AnyObject{
    func didTapButton(cell: CustomCell, index: IndexPath)
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var spotTitle: UILabel!
    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var spotCategory: UILabel!
    @IBOutlet weak var spotAddress: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var ratingAmount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var delegate: CellDelegate?
    var index: IndexPath?
    var spotId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cameraButton.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("row is tapped")
        // Configure the view for the selected state
    }

    
    @IBAction func likeAction(_ sender: UIButton) {
        print("heart is tapped")
        
        self.delegate?.didTapButton(cell: self, index: index!)
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        print("camera is tapped")
    }
}
