//
//  ViewController.swift
//  Semestralka
//
//  Created by Cyril on 09/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
class EnterURLController : FormViewController {
    
    var urlRow: URLRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.backgroundColor = UIColor.whiteColor()
        addForms(toForm: form)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        urlRow.cell?.becomeFirstResponder()
        urlRow.cell?.textField.selectAll(urlRow.cell)
    }
    
    
    private func addForms(toForm form: Form) {
        
        urlRow = URLRow() {
            $0.placeholder = "http://myfatfreecrm.com"
            $0.tag = "url"
            $0.cellSetup({ (cell, row) in
                cell.becomeFirstResponder()
            }) }
        
        form +++ Section("Enter Server Url")
            <<< urlRow
        
        form +++ Section("")
            <<< ButtonRow() {
                $0.title = "Connect"
                $0.onCellSelection({ (cell, row) in
                    print(form.values())
                    let urlPath: NSURL? = form.values()["url"] as? NSURL
                    let url: String? = urlPath?.absoluteString
                    if (url == nil) {
                        let alertController = UIAlertController(title: "URL cannot be empty!", message: "Please fill the form correctly.", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        }
                        alertController.addAction(OKAction)
                        self.presentViewController(alertController, animated: true){}
                    } else {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(url, forKeyPath: "url")
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                        self.showViewController(vc, sender: self)
                    }
                })
                $0.cellSetup({ (cell, row) in
                })
                
        }
        
    }
    
}
