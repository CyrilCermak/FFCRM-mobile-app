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

class ContactsDetailVC: FormViewController {
    
    var contact = Contact()
    var contactsVC:ContactsVC = ContactsVC()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContact(toForm: form)
        addAddress(toForm: form)
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
    
    func turnMenuOn(){
        self.navigationController?.sideMenuController()?.sideMenu?.menuWidth = appDelegate.getSideMenuSize()
        print(appDelegate.getSideMenuSize())
        self.navigationController?.sideMenuController()?.sideMenu?.allowLeftSwipe = true
        self.navigationController?.sideMenuController()?.sideMenu?.allowRightSwipe = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationController?.sideMenuController()?.sideMenu?.menuWidth = 0
        self.navigationController?.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.navigationController?.sideMenuController()?.sideMenu?.allowRightSwipe = false
        if segue.identifier == "EditContactSegue" {
            print("Edit Contact Segue")
            let navController = segue.destinationViewController as! UINavigationController
            let editVC = navController.topViewController as! EditContactVC
            editVC.contact = self.contact
            editVC.contactsDetailVC = self
            editVC.contactsVC = self.contactsVC
        }
    }
    
    private func addAddress(toForm form: Form){
        form +++ Section("Address Details")
            <<< TextRow { $0.value = "Street"; $0.tag = "street" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
            
            <<< TextRow { $0.value = "City"; $0.tag = "city" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
            
            <<< TextRow { $0.value = "State"; $0.tag = "state" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
            
            <<< TextRow { $0.value = "Zip Code"; $0.tag = "zip" }.cellSetup({ (cell, row) in
                cell.userInteractionEnabled = false
            })
            <<< ButtonRow() {
                $0.title = "Delete Account"
                $0.cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.redColor()
                })
                }.onCellSelection({ (cell, row) in
                    let contactModel = Contacts()
                    print("Deleting contact \(self.contact)")
                    contactModel.removeContact(self.contact)
                    let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { alert in
                        self.navigationController?.popViewControllerAnimated(true)
                        HUD.flash(.Label("Deleting Account..."), delay: 4.0, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
    }
    
}
