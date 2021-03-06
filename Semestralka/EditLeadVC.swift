//
//  LeadDetailVC.swift
//  Semestralka
//
//  Created by Cyril on 26/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
class EditLeadVC: FormViewController {
    
    var nameRow : TextRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.backgroundColor = UIColor.whiteColor()
        addSections(toForm: form)
    }
    
    override func viewDidAppear(animated: Bool) {
        nameRow.cell?.becomeFirstResponder()
        nameRow.cell?.textField.selectAll(nameRow.cell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSaveClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func buttonCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addSections(toForm form: Form) {
        nameRow = TextRow {$0.value = "Cyril Cermak"}
        form +++ Section("Name")
            <<< nameRow
        form +++ Section("Phone")
            <<< TextRow {$0.value = "00420 776208919"}
        form +++ Section("Email")
            <<< TextRow {$0.value = "cyril.cermak@gmail.com"}
        form +++ Section("Status")
            <<< TextRow {$0.value = "Contacted"}
        
    }
    
}
