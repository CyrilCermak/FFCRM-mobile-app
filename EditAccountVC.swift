//
//  EditAccountVC.swift
//  Semestralka
//
//  Created by Cyril on 26/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
class EditAccountVC: FormViewController {
    
    var rowName : TextRow!
    var selectedAccount:Account = Account()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        addName(toForm: form)
        addCategories(toForm:form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func buttonSaveClicked(sender: AnyObject) {
        print(form.values())
        selectedAccount.assignTo = form.values()["assignTo"] as? String
        selectedAccount.email = form.values()["email"] as? String
        selectedAccount.phone = form.values()["phone"] as? String
        selectedAccount.rating = form.values()["rating"] as? Int
        selectedAccount.name = form.values()["name"] as? String
        let accountModel = Accounts()
        accountModel.updateAccount(selectedAccount)
//        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    private func addName(toForm form: Form){
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
    
    private func addCategories(toForm form: Form){
        var assignTo: String
        var phone: String
        if selectedAccount.assignTo == nil {
            assignTo = ""
        }else {
            assignTo = selectedAccount.assignTo!
        }
        if selectedAccount.phone == nil {
            phone = ""
        }else {
            phone = selectedAccount.phone!
        }
        form +++ Section("Assigned to")
            <<< TextRow(){
                $0.value = assignTo
                $0.tag = selectedAccount.assignTo
                }.cellSetup({ (cell, row) in
                    cell.userInteractionEnabled = false
                })
        form +++ Section("Phone")
            <<< TextRow() {
                $0.value = phone
                $0.tag = "phone"
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
        let i: Int? = selectedAccount.rating
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailVCSegue" {
            print("in segueeeeeeeeee")
            selectedAccount.assignTo = form.values()["assignTo"] as? String
            selectedAccount.email = form.values()["email"] as? String
            selectedAccount.phone = form.values()["phone"] as? String
            selectedAccount.rating = 1
            selectedAccount.name = form.values()["name"] as? String
            print(selectedAccount)
                let vc = segue.destinationViewController as! AccountDetailVC
            vc.selectedAccount = selectedAccount
            
        }
    }
    
    
}
