//
//  CustomCell.swift
//  Semestralka
//
//  Created by Cyril on 04.06.16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var cloudImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
