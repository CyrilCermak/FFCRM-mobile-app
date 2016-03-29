//
//  NewAccountVC2.swift
//  Semestralka
//
//  Created by Cyril on 24/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka

class DashboardVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAccounts(toForm: form)
        addContacts(toForm: form)
        addLeads(toForm: form)
        self.tableView?.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
         self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        //COMENT LINE TO ENABLE USER LOGIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //appDelegate.isLoggedIn = true
        if (appDelegate.isLoggedIn == false){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let login = storyboard.instantiateViewControllerWithIdentifier("loginNavigationController")
            login.modalTransitionStyle = .CoverVertical
            presentViewController(login, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createButtonClicked(sender: AnyObject) {
        print(form.values())
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func addAccounts(toForm form: Form){
        form +++ Section("Accounts")
            <<< ButtonRow() {
                $0.title = "Show Accounts"
                $0.cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.blackColor()
                })
                $0.onCellSelection({ (cell, row) in
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("AccountsVC") as! AccountsVC
                    self.showViewController(vc, sender: vc)
                })}
            <<< ButtonRow() {
                $0.title = "Create Account"
                $0.cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.blackColor()
                })
                $0.onCellSelection({ (cell, row) in
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("AccountsVC") as! AccountsVC
                    self.showViewController(vc, sender: vc)
                })}
    }
    
    private func addContacts(toForm form: Form){
        form +++ Section("Contacts")
            <<< ButtonRow {
                $0.title = "Show Contacts"
                $0.cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.blackColor()
                })
            $0.onCellSelection({ (cell, row) in
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ContactsVC") as! ContactsVC
                self.showViewController(vc, sender: vc)

            })}
            
            <<< ButtonRow {
                $0.title = "Create Contact"
                $0.cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.blackColor()
                })
                $0.onCellSelection({ (cell, row) in
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ContactsVC") as! ContactsVC
                    self.showViewController(vc, sender: vc)
                })}
        
    }
    
    private func addLeads(toForm form: Form) {
        form +++ Section("Leads")
        <<< ButtonRow { $0.title = "Show Leads"
            $0.cellSetup({ (cell, row) in
                cell.tintColor = UIColor.blackColor()
            })
            $0.onCellSelection({ (cell, row) in
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LeadsVC") as! LeadsVC
                self.showViewController(vc, sender: vc)
            })}
            <<< ButtonRow {
                $0.title = "Create Lead"
                $0.cellSetup({ (cell, row) in
                    cell.tintColor = UIColor.blackColor()
                })
                $0.onCellSelection({ (cell, row) in
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LeadsVC") as! LeadsVC
                    self.showViewController(vc, sender: vc)
                })}
    
    }
    
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}
