//
//  WriterCell.swift
//  StartLens
//
//  Created by 中野　裕太 on 2020/06/11.
//  Copyright © 2020 Nakano Yuta. All rights reserved.
//

import UIKit
import Cosmos


class WriterCell: UITableViewCell {

    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var reviewPosted: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
