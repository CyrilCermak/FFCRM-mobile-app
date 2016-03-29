//
//  ViewController.swift
//  Semestralka
//
//  Created by Cyril on 09/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
class LoginVC : FormViewController {
    
    
    var nameRow: TextRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.backgroundColor = UIColor.whiteColor()
        addForms(toForm: form)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameRow.cell?.becomeFirstResponder()
        nameRow.cell?.textField.selectAll(nameRow.cell)
    }
    
    @IBAction func buttonConnectClicked(sender: AnyObject) {
        print(form.values())
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.isLoggedIn = true
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    private func addForms(toForm form: Form) {
        nameRow = TextRow() {
            $0.placeholder = "Name"
            $0.tag = "name"
            $0.cellSetup({ (cell, row) in
                cell.becomeFirstResponder()
            })
        }
        form +++ Section("")
        form +++ Section("Login Name")
            <<< nameRow
        form +++ Section("Password")
            <<< PasswordRow() {
                $0.placeholder = "Password"
                $0.tag = "password"
                $0.cellSetup({ (cell, row) in
                    cell.becomeFirstResponder()
                })
        }
        
    }
    
}
