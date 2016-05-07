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
    
    var selectedAccount: AnyObject?
    var accountsVC: AnyObject?
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCategories(toForm:form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        appDel.menuShowed = false
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    func turnOnMenu(){
        self.navigationController?.sideMenuController()?.sideMenu?.menuWidth = appDelegate.getSideMenuSize()
        self.navigationController?.sideMenuController()?.sideMenu?.allowLeftSwipe = true
        self.navigationController?.sideMenuController()?.sideMenu?.allowRightSwipe = true
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
            self.navigationController?.sideMenuController()?.sideMenu?.menuWidth = 0
            self.navigationController?.sideMenuController()?.sideMenu?.allowLeftSwipe = false
            self.navigationController?.sideMenuController()?.sideMenu?.allowRightSwipe = false
            let navController = segue.destinationViewController as! UINavigationController
            let editAccountVC = navController.topViewController as! EditAccountVC
            print(selectedAccount)
            editAccountVC.selectedAccount = self.selectedAccount as! Account
            editAccountVC.accountDetailVC = self 
        }
    }
    
    private func addCategories(toForm form: Form){
        var account = selectedAccount as! Account
        
        var name: String {
            if let name = account.name {
                return name
            }
            return ""
        }
        var phone: String {
            if let phone = account.phone {
                return phone
            }
            return ""
        }
        var email: String {
            if let email = account.email {
                return email
            }
            return ""
        }
        var assignTo: String {
            if let aT = account.assignTo {
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
                    let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { alert in
                        self.navigationController?.popViewControllerAnimated(true)
                        let accountModel = Accounts()
                        print("removing account \(self.selectedAccount)")
                        accountModel.removeAccount(self.selectedAccount as! Account)
                        HUD.flash(.Label("Deleting Account..."), delay: 7.0, completion: { completed in
                            let aVC = self.accountsVC as! AccountsVC
                            aVC.refreshTable()
                        })
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
    }
    
    func getStars() -> String {
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
