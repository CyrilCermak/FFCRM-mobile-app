//
//  NewLeadVC.swift
//  Semestralka
//
//  Created by Cyril on 26/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka

class NewLeadVC: FormViewController {
    
    var nameRow : TextRow!
    override func viewDidLoad() {
        super.viewDidLoad()
        addForm(toForm: form)
    }
    
    override func viewDidAppear(animated: Bool) {
        nameRow.cell?.becomeFirstResponder()
        nameRow.cell?.textField.selectAll(nameRow.cell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addForm(toForm form: Form) {
        nameRow = TextRow {
            $0.placeholder = "Name"
            $0.tag = "name"
        }
        form +++ Section("")
        form +++ Section("")
            <<< nameRow
            <<< PhoneRow { $0.placeholder = "Phone"; $0.tag = "phone"}
            <<< EmailRow { $0.placeholder = "Email"; $0.tag = "email"}
            <<< AlertRow<String>("status") {
                $0.options = ["Customer","Competitor","Reseller"];
                $0.value = "Customer"
                $0.title = "Status"
                $0.tag = "status"
        }
        
    }
    
    @IBAction func buttonCreateClicked(sender: AnyObject) {
        print(form.values())
        navigationController?.popViewControllerAnimated(true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
