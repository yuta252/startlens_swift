//
//  LanguageCell.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/28.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    @IBOutlet weak var languageText: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
