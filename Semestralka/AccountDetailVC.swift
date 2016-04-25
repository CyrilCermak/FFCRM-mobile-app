//
//  AccountDetailVC.swift
//  Semestralka
//
//  Created by Cyril on 18/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
import PKHUD

class AccountDetailVC: FormViewController {
    
    var selectedAccount = Account()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCategories(toForm:form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        appDel.menuShowed = false
    }
    
    
    @IBAction func buttonCreateClicked(sender: AnyObject) {
        print(form.values(includeHidden: true))
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editAccountSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let editAccountVC = navController.topViewController as! EditAccountVC
            print(selectedAccount)
            editAccountVC.selectedAccount = self.selectedAccount
        }
    }
    
    
    private func addCategories(toForm form: Form){
        
        var name: String {
            if let name = selectedAccount.name {
                return name
            }
            return ""
        }
        var phone: String {
            if let phone = selectedAccount.phone {
                return phone
            }
            return ""
        }
        var email: String {
            if let email = selectedAccount.email {
                return email
            }
            return ""
        }
        var assignTo: String {
            if let aT = selectedAccount.assignTo {
                return aT
            }
            return ""
        }
        form +++ Section("Account Details")
            <<< TextRow { $0.value = "Name \(name)" }.cellSetup {cell, row in
                cell.userInteractionEnabled = false
            }
            <<< TextRow() {
                $0.value = "Phone: \(phone)"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
            <<< TextRow() {
                $0.value = "Email: \(email)"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
            <<< TextRow(){
                $0.value = "Assigned to: \(assignTo)"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
            <<< TextRow() {
                $0.value = "Ratings: \(getStars())"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
            +++ Section("")
            <<< ButtonRow() {
                $0.title = "Delete Account"
                $0.cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.redColor()
                })
                }.onCellSelection({ (cell, row) in
                    let accountModel = Accounts()
                    accountModel.removeAccount(self.selectedAccount)
                    let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { alert in
                        self.navigationController?.popViewControllerAnimated(true)
                        HUD.flash(.Label("Deleting Account..."), delay: 4.0, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
    }
    
    
    func getStars() -> String {
//        let i = selectedAccount.rating
        let i = 1
        var x = 1
        var stars = ""
        while x < i {
            stars.appendContentsOf("*")
            x = x + 1
        }
        return stars
    }
    
}
