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
        let contactsModel = Contacts()
        var contact = Contact()
        contact.first_name = self.form.values()["first_name"] as! String?
        contact.last_name = self.form.values()["last_name"] as! String?
        contact.email = self.form.values()["email"] as! String?
        contact.mobile = self.form.values()["mobile"] as! String?
        contact.phone = self.form.values()["phone"] as! String?
        contactsModel.createContact(contact)
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func addContact(toForm form: Form){
        titleRow = TextRow() {
            $0.placeholder = "Title"
            $0.tag = "title" }
        
        form +++ Section("Contact Details")
            <<< titleRow
        form +++ Section("First name")
            <<< TextRow { $0.value = ""; $0.tag = "first_name"; $0.placeholder = "First name"}
        form +++ Section("Last name")
            <<< TextRow { $0.value = ""; $0.tag = "last_name"; $0.placeholder = "Last name" }
        form +++ Section("Phone")
            <<< TextRow { $0.value = ""; $0.tag = "phone"; $0.placeholder = "Phone" }
        form +++ Section("Mobile")
            <<< TextRow { $0.value = ""; $0.tag = "mobile"; $0.placeholder = "Mobile" }
        form +++ Section("Email")
            <<< TextRow { $0.value = ""; $0.tag = "email"; $0.placeholder = "Email" }
    }
    
    private func addAddress(toForm form: Form){
        form +++ Section("Address Details")
            <<< TextRow { $0.placeholder = "Street"; $0.tag = "street" }
            <<< TextRow { $0.placeholder = "City"; $0.tag = "city" }
            <<< TextRow { $0.placeholder = "State"; $0.tag = "state" }
            <<< TextRow { $0.placeholder = "Zip Code"; $0.tag = "zip" }
    }
}