//
//  AccountDetailVC.swift
//  Semestralka
//
//  Created by Cyril on 18/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka

class AccountDetailVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addName(toForm: form)
        addCategories(toForm:form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
    }
    
    
    @IBAction func buttonCreateClicked(sender: AnyObject) {
        print(form.values(includeHidden: true))
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addName(toForm form: Form){
        form +++ Section("Name")
            <<< TextRow { $0.value = "Name" }.cellSetup {cell, row in
            cell.userInteractionEnabled = false
        }
    }
    
    private func addCategories(toForm form: Form){
        form +++ Section("Assigned To")
            <<< TextRow(){
                $0.value = "My Self"
        }.cellSetup({ (cell, row) in
           cell.userInteractionEnabled = false
        })
        form +++ Section("Category")
            <<< TextRow() {
                $0.value = "Affiliate"
               
        }.cellSetup({ (cell, row) in
            cell.userInteractionEnabled = false
        })
        form +++ Section("Rating")
            <<< TextRow() {
                $0.value = "*"
        }.cellSetup({ (cell, row) in
            cell.userInteractionEnabled = false
        })
        
    }
    
}
