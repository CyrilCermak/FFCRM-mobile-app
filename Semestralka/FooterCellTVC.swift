//
//  FooterCellTVC.swift
//  Semestralka
//
//  Created by Cyril on 31/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

class FooterCellTVC: UITableViewCell {
    
    @IBOutlet var buttonShow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonShowAccounts(sender: UIButton){
        print("buttonClicked")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
