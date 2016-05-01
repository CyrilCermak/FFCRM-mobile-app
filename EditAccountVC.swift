//
//  EditAccountVC.swift
//  Semestralka
//
//  Created by Cyril on 26/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
import PKHUD
import MagicalRecord

class EditAccountVC: FormViewController {
    
    var rowName : TextRow!
    var selectedAccount: AnyObject?
    var accountDetailVC: AccountDetailVC?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.dimsBackground = true
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        let account = selectedAccount as! Account
        addName(toForm: form, selectedAccount: account)
        addCategories(toForm:form, selectedAccount: account)
        self.tableView?.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func buttonSaveClicked(sender: AnyObject) {
        var rating:Int32 {
            if let rating = form.values()["rating"] {
                return rating as! Int32
            }
            return 0
        }
        let account = selectedAccount as! Account
        let oldAccountParams: [String: AnyObject?]
        oldAccountParams = ["email": account.email,"phone":account.phone , "name":account.name, "assignTo":account.assignTo]
        account.assignTo = form.values()["assignTo"] as? String
        account.email = form.values()["email"] as? String
        account.phone = form.values()["phone"] as? String
        account.rating = rating
        account.name = form.values()["name"] as? String
        appDelegate.persistContext()
        let accountModel = Accounts()
        accountModel.updateAccount(account, accountsVC: (accountDetailVC?.accountsVC) as? AccountsVC, oldAccountParams: oldAccountParams)
        navigationController!.dismissViewControllerAnimated(true, completion: {
            self.accountDetailVC!.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    @IBAction func buttonCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        rowName.cell?.becomeFirstResponder()
        rowName.cell?.textField.selectAll(rowName.cell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addName(toForm form: Form, selectedAccount: Account){
        var name: String
        if  selectedAccount.name == nil {
            name = ""
        } else {
            name = selectedAccount.name!
        }
        rowName = TextRow {$0.value = name; $0.tag = "name"}
        form +++ Section("Name")
            <<< rowName
    }
    
    private func addCategories(toForm form: Form, selectedAccount: Account){
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
        
        form +++ Section("Phone")
            <<< TextRow() {
                $0.value = phone
                $0.tag = "phone"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
        form +++ Section("Email")
            <<< TextRow(){
                $0.value = email
                $0.tag = "email"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
        form +++ Section("Assigned to")
            <<< TextRow(){
                $0.value = assignTo
                $0.tag = "assignTo"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
        form +++ Section("Ratings")
            <<< TextRow() {
                $0.value = getStars()
                $0.tag = "ratings"
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
    }
    
    func getStars() -> String {
        let account = selectedAccount as! Account
        let i: Int? = Int(account.rating)
        var x = 1
        var stars = ""
        if i != nil {
            while x < i {
                stars.appendContentsOf("*")
                x = x + 1
            }
        }
        return stars
    }
    
}
