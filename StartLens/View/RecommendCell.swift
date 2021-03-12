//
//  RecommendCell.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/11.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class RecommendCell: UICollectionViewCell {

    @IBOutlet weak var exhibitImageView: UIImageView!
    @IBOutlet weak var exhibitName: UILabel!
    @IBOutlet weak var layoutWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialize
        setCellWidth((UIScreen.main.bounds.width - 50) / 2)
    }
    
    func setCellWidth(_ width: CGFloat) {
        layoutWidth?.constant = width
        print("Action: setCellWidth, width: \(width)")
    }

}
