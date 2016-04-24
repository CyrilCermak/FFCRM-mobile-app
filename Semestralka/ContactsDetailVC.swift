//
//  NewAccountVC2.swift
//  Semestralka
//
//  Created by Cyril on 24/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka

class ContactsDetailVC: FormViewController {
    
    var contact = Contact()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContact(toForm: form)
     //   addAddress(toForm: form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
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
        print("In Detail \(contact)")
        
        var mobile:String
        var phone:String
        var email:String
        var department:String
        
        if (contact.mobile == nil) {
            mobile = ""
        }else {
            mobile = contact.mobile!
        }
        if (contact.phone == nil) {
            phone = ""
        }else {
            phone = contact.phone!
        }
        if (contact.email == nil){
            email = ""
        }else {
            email = contact.email!
        }
        if (contact.department == nil) {
            department = ""
        }else {
            department = contact.department!
        }
        
        
        form +++ Section("Contact Details")
            <<< TextRow { $0.value = "Name: \(contact.first_name) \(contact.last_name)"; $0.placeholder = "Title"; $0.tag = "title" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
            
            <<< PhoneRow { $0.value = "Mobile: \(mobile)"; $0.tag = "mobile" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
            
            <<< TextRow { $0.value = "Phone: \(phone)"; $0.tag = "phone" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })

            <<< TextRow { $0.value = "Email: \(email)"; $0.tag = "email" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
            
            <<< TextRow { $0.value = "Department: \(department)"; $0.tag = "department" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })

    }
    
//    private func addAddress(toForm form: Form){
//        form +++ Section("Address Details")
//            <<< TextRow { $0.value = "Street"; $0.tag = "street" }.cellSetup({ (cell, row) in
//                cell.userInteractionEnabled = false
//            })
//
//            <<< TextRow { $0.value = "City"; $0.tag = "city" }.cellSetup({ (cell, row) in
//                cell.userInteractionEnabled = false
//            })
//
//            <<< TextRow { $0.value = "State"; $0.tag = "state" }.cellSetup({ (cell, row) in
//                cell.userInteractionEnabled = false
//            })
//
//            <<< TextRow { $0.value = "Zip Code"; $0.tag = "zip" }.cellSetup({ (cell, row) in
//                cell.userInteractionEnabled = false
//            })
//        
//    }
    
}
