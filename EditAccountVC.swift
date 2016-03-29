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
        rowName = TextRow {$0.value = "Name"; $0.tag = "name"}
        form +++ Section("Name")
            <<< rowName
    }
    
    private func addCategories(toForm form: Form){
        form +++ Section("Assigned To")
            <<< TextRow(){
                $0.value = "My Self"
                $0.tag = "assignedTo"
        }
        form +++ Section("Category")
            <<< TextRow() {
                $0.value = "Affiliate"
                $0.tag = "affiliate"
                
        }
        form +++ Section("Rating")
            <<< TextRow() {
                $0.value = "*"
                $0.tag = "rating"
        }
    }
    
    
}
