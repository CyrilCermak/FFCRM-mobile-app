//
//  NewAccountVC2.swift
//  Semestralka
//
//  Created by Cyril on 24/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
import PKHUD

class EditContactVC: FormViewController {
    
    var titleRow: TextRow!
    var contact = Contact()
    var contactsDetailVC = ContactsDetailVC()
    var contactsVC:ContactsVC = ContactsVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContact(toForm: form)
        addAddress(toForm: form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        titleRow.cell?.becomeFirstResponder()
        titleRow.cell?.textField.selectAll(titleRow.cell)
    }
    
    @IBAction func buttonSaveClicked(sender: AnyObject) {
        let contactsModel = Contacts()
        contact.first_name = self.form.values()["first_name"] as! String?
        contact.last_name = self.form.values()["last_name"] as! String?
        contact.email = self.form.values()["email"] as! String?
        contact.mobile = self.form.values()["mobile"] as! String?
        contact.phone = self.form.values()["phone"] as! String?
        contactsModel.updateContact(contact)
        navigationController!.dismissViewControllerAnimated(true, completion: {
            self.contactsDetailVC.navigationController?.popViewControllerAnimated(true)
                self.contactsDetailVC.turnMenuOn()
            HUD.flash(.Label("Saving Account..."), delay: 8.0, completion: { completed in
                NSNotificationCenter.defaultCenter().postNotificationName("reloadContacts",object: nil)
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            self.contactsDetailVC.turnMenuOn()
        })
    }
    
    private func addContact(toForm form: Form){
        titleRow = TextRow { $0.value = "Title"; $0.tag = "title" }
        
        var phone: String {
            if let phone = contact.phone {
                return phone
            }
            return ""
        }
        var email: String {
            if let email = contact.email {
                return email
            }
            return ""
        }
        var mobile: String {
            if let mobile = contact.mobile {
                return mobile
            }
            return ""
        }

        form +++ Section("Contact Details")
            <<< titleRow
        form +++ Section("First name")
            <<< TextRow { $0.value = contact.first_name!; $0.tag = "first_name" }
        form +++ Section("Last name")
            <<< TextRow { $0.value = contact.last_name; $0.tag = "last_name" }
        form +++ Section("Phone")
            <<< TextRow { $0.value = phone; $0.tag = "phone" }
        form +++ Section("Mobile")
            <<< TextRow { $0.value = mobile; $0.tag = "mobile" }
        form +++ Section("Email")
            <<< TextRow { $0.value = email; $0.tag = "email" }
    }
    
    private func addAddress(toForm form: Form){
        form +++ Section("Address Details")
            form +++ Section("Street")
            <<< TextRow { $0.value = ""; $0.tag = "street"; $0.placeholder = "street" }
            form +++ Section("City")
            <<< TextRow { $0.value = ""; $0.tag = "city"; $0.placeholder = "city" }
            form +++ Section("State")
            <<< TextRow { $0.value = ""; $0.tag = "state"; $0.placeholder = "state" }
            form +++ Section("Zip Code")
            <<< TextRow { $0.value = ""; $0.tag = "zip"; $0.placeholder = "zip" }
    }
    
}
