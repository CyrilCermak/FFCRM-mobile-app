//
//  NewAccountVC2.swift
//  Semestralka
//
//  Created by Cyril on 24/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka

class EditContactVC: FormViewController {
    
    var titleRow: TextRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContact(toForm: form)
        addAddress(toForm: form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
        // set style to navigation controller
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        titleRow.cell?.becomeFirstResponder()
        titleRow.cell?.textField.selectAll(titleRow.cell)
    }
    
    @IBAction func buttonSaveClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func addContact(toForm form: Form){
        titleRow = TextRow { $0.value = "Title"; $0.tag = "title" }
        
        form +++ Section("Contact Details")
            <<< titleRow
            
            <<< TextRow { $0.value = "Name"; $0.tag = "name" }
            
            <<< TextRow { $0.value = "Phone"; $0.tag = "phone" }
            
            <<< TextRow { $0.value = "Email"; $0.tag = "email" }
        
    }
    
    private func addAddress(toForm form: Form){
        form +++ Section("Address Details")
            <<< TextRow { $0.value = "Street"; $0.tag = "street" }
            
            <<< TextRow { $0.value = "City"; $0.tag = "city" }
            
            <<< TextRow { $0.value = "State"; $0.tag = "state" }
            
            <<< TextRow { $0.value = "Zip Code"; $0.tag = "zip" }
    }
    
}
