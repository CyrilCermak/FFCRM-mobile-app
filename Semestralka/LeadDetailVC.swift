//
//  LeadDetailVC.swift
//  Semestralka
//
//  Created by Cyril on 26/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
class LeadDetailVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.backgroundColor = UIColor.whiteColor()
        addSections(toForm: form)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSections(toForm form: Form) {
        form +++ Section("")
        form +++ Section("")
        form +++ Section("Name")
            <<< TextRow {$0.value = "Cyril Cermak" ; $0.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })}
        form +++ Section("Phone")
            <<< TextRow {$0.value = "00420 776208919" ; $0.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
        }
        form +++ Section("Email")
            <<< TextRow {$0.value = "cyril.cermak@gmail.com"; $0.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })}
        form +++ Section("Status")
            <<< TextRow {$0.value = "Contacted" ; $0.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })}
    }
    
    
}
