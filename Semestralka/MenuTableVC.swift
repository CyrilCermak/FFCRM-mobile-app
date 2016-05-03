//
//  MenuTableVC.swift
//  Semestralka
//
//  Created by Cyril on 16/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka
import KeychainSwift

class MenuTableVC: FormViewController {
    
    
    let cellColor = UIColor.init(red:0.037, green:0.777, blue:0.118, alpha:1.00)
    let textColor = UIColor.whiteColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundColor = UIColor.whiteColor()
        addButtons(toForm: form)
        self.tableView?.showsHorizontalScrollIndicator = false
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.backgroundColor = cellColor
    }
    
    private func addButtons(toForm form: Form) {
        form +++ Section("")
        form  +++ Section("")
            <<< ButtonRow {
                $0.title = "Dashoard"
                }.cellSetup({ (cell, row) in
                    cell.tintColor = self.textColor
                    cell.backgroundColor = self.cellColor
                }).onCellSelection({ (cell, row) in
                    cell.backgroundColor = UIColor.whiteColor()
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("DashboardVC")
                    as! DashboardVC
                   self.sideMenuController()?.setContentViewController(vc)
                })
            
            <<< ButtonRow {
                $0.title = "Accounts"
                }.cellSetup({ (cell, row) in
                    cell.tintColor = self.textColor
                    cell.backgroundColor = self.cellColor
                }).onCellSelection({ (cell, row) in
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("AccountsVC") as! AccountsVC
                    self.sideMenuController()?.setContentViewController(vc)
                })
            <<< ButtonRow {
                $0.title = "Contacts"
                }.cellSetup({ (cell, row) in
                    cell.tintColor = self.textColor
                    cell.backgroundColor = self.cellColor
                }).onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsVC")
                        as! ContactsVC
                    self.sideMenuController()?.setContentViewController(vc)

                })
            <<< ButtonRow {
                $0.title = "Leads"
                }.cellSetup({ (cell, row) in
                    cell.tintColor = self.textColor
                    cell.backgroundColor = self.cellColor
                }).onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LeadsVC")
                        as! LeadsVC
                    self.sideMenuController()?.setContentViewController(vc)
                })
        form  +++ Section("")
        form  +++ Section("")
        form  +++ Section("")
        form  +++ Section("")
        form  +++ Section("")
        form  +++ Section("")
            <<< ButtonRow {
                $0.title = "About"
                }.cellSetup({ (cell, row) in
                    cell.tintColor = self.textColor
                    cell.backgroundColor = self.cellColor
                }).onCellSelection({ (cell, row) in
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AboutVC")
                        as! AboutVC
                    self.sideMenuController()?.setContentViewController(vc)
                })
            
            <<< ButtonRow {
                $0.title = "Log Out"
                }.cellSetup({ (cell, row) in
                    cell.tintColor = self.textColor
                    cell.backgroundColor = self.cellColor
                }).onCellSelection({ (cell, row) in
                    let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { alert in
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as! MenuVC
                        let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
                        appDelegate.isLoggedIn = false
                        appDelegate.keyChain.delete("password")
                        appDelegate.keyChain.delete("userName")
                        appDelegate.keyChain.delete("base64")
                        self.showViewController(vc, sender: nil)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
    
    }
    
    
    
}
