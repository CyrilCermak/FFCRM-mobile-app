//
//  NewAccountVC2.swift
//  Semestralka
//
//  Created by Cyril on 24/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka

class NewContactVC: FormViewController {
    
    var titleRow: TextRow!

    override func viewDidLoad() {
        super.viewDidLoad()
        addContact(toForm: form)
        addAddress(toForm: form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        titleRow.cell?.becomeFirstResponder()
        titleRow.cell?.textField.selectAll(titleRow.cell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createButtonClicked(sender: AnyObject) {
        print(form.values())
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func addContact(toForm form: Form){
        titleRow = TextRow() {
            $0.placeholder = "Title"
            $0.tag = "title" }
        form +++ Section("Contact Details")
            <<< titleRow
            <<< TextRow { $0.placeholder = "Name"; $0.tag = "name" }
            <<< TextRow { $0.placeholder = "Phone"; $0.tag = "phone" }
            <<< TextRow { $0.placeholder = "Email"; $0.tag = "email" }
    }
    
    private func addAddress(toForm form: Form){
        form +++ Section("Address Details")
            <<< TextRow { $0.placeholder = "Street"; $0.tag = "street" }
            <<< TextRow { $0.placeholder = "City"; $0.tag = "city" }
            <<< TextRow { $0.placeholder = "State"; $0.tag = "state" }
            <<< TextRow { $0.placeholder = "Zip Code"; $0.tag = "zip" }
    }
}