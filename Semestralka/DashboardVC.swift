//
//  NewAccountVC2.swift
//  Semestralka
//
//  Created by Cyril on 24/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Eureka

class DashboardVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var leads = [Lead(name: "Adam", status: "Customer"),
                         Lead(name: "Adam", status: "Customer"),
                         Lead(name: "Adam", status: "Customer")]

    var accounts: [Account]?
    var contacts: [Contact]?
    var sections = ["Accounts", "Contacts","Leads"]
    let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate

    @IBOutlet var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        var loggedIn = appDelegate.defaults.valueForKey("LoggedIn") as? String
        if loggedIn == "yes" {
            createAccounts()
            createContacts()
            leads = [Lead(name: "Adam", status: "Customer"),
                     Lead(name: "Adam", status: "Customer"),
                     Lead(name: "Adam", status: "Customer")]
        }
        self.tableView.reloadData()
        print(contacts)
    }
    
    private func createContacts(){
        let contactsArrays = appDelegate.getContacts().values
        if contactsArrays.count > 0 {
            contacts = [Contact]()
            var i = 0
            for contactsArray in contactsArrays {
                for contact in contactsArray {
                    if i == 3 {
                     break
                    }
                    i = i + 1
                    contacts?.append(contact)
                }
            }
        }
    }
    
    private func createAccounts() {
        accounts = [Account]()
        let accountArrays = appDelegate.getAccounts().values
        var i = 0
        for accountArray in accountArrays {
            for account in accountArray {
                if i == 3 {
                    break
                }
                self.accounts!.append(account)
                i = i + 1
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let loggedIn = appDelegate.defaults.valueForKey("LoggedIn") as? String
        if (loggedIn == nil || loggedIn != "yes"){
            appearLogin()
        } else {
            let c = Contacts()
            c.loadContacts({ (completed) in
                if completed {
                    print("completed")
                    self.createContacts()
                }
            })
        }
        self.tableView.reloadData()
    }
    
    func appearLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyboard.instantiateViewControllerWithIdentifier("loginNavigationController")
        login.modalTransitionStyle = .CoverVertical
        presentViewController(login, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.section)
        if (indexPath.section == 1){
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsDetailVC") as! ContactsDetailVC
            vc.contact = contacts![indexPath.row]
            showViewController(vc, sender: self)
        }else if (indexPath.section == 2) {
            print(2)
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LeadDetailVC") as! LeadDetailVC
            showViewController(vc, sender: self)
            
        }else {
            print(3)
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AccountDetailVC") as! AccountDetailVC
            vc.selectedAccount = accounts![indexPath.row]
            showViewController(vc, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.center
        if (indexPath.section == 1){
            let contact = contacts?[indexPath.row]
            var firstName: String {
                if let contact = contact?.first_name {
                    return contact
                }
                return ""
            }
            var lastName: String {
                if let contact = contact?.last_name {
                    return contact
                }
                return ""
            }
            cell.textLabel!.text = contacts?[indexPath.row].email!
            cell.detailTextLabel?.text = "\(firstName) \(lastName)"
        }else if (indexPath.section == 2) {
            cell.textLabel?.text  = leads[indexPath.row].status
            cell.detailTextLabel?.text = leads[indexPath.row].name
        }else {
            cell.textLabel?.text = accounts?[indexPath.row].category
            cell.detailTextLabel?.text = accounts?[indexPath.row].name
        }
        cell.backgroundColor = UIColor.whiteColor()
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light" , size: 20)
        return cell
    }
    
    @IBOutlet var buttonAddClicked: UIBarButtonItem!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCellTVC
        cell.label.text = sections[section]
        cell.backgroundColor = UIColor.blackColor()
        cell.label.textColor = UIColor.whiteColor()
        cell.label?.font = UIFont(name: "Avenir-Light" , size: 25)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("FooterCell") as! FooterCellTVC
//        cell.buttonShow.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cell.buttonShow.titleLabel!.font = UIFont(name: "Avenir-Light" , size: 20)
        if (section == 1){
            cell.buttonShow.setTitle("Show Contacts", forState: UIControlState.Normal)
            cell.buttonShow.addTarget(self, action: #selector(DashboardVC.buttonShowContacts(_:)), forControlEvents: .TouchUpInside)
        } else if (section == 2) {
            cell.buttonShow.setTitle("Show Leads", forState: UIControlState.Normal)
            cell.buttonShow.addTarget(self, action: #selector(DashboardVC.buttonShowLeads(_:)), forControlEvents: .TouchUpInside)
        } else {
            cell.buttonShow.setTitle("Show Accounts", forState: UIControlState.Normal)
            cell.buttonShow.addTarget(self, action: #selector(DashboardVC.buttonShowAccounts(_:)), forControlEvents: .TouchUpInside)
        }
        return cell
    }
    
    @IBAction func buttonAddClicked(sender: AnyObject) {
        let alert = UIAlertController(title: "Create New", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Account", style: UIAlertActionStyle.Default, handler: { action in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NewAccountVC") as! NewAccountVC
            self.showViewController(vc, sender: vc)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Contact", style: UIAlertActionStyle.Default, handler: { action in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NewContactVC") as! NewContactVC
            self.showViewController(vc, sender: vc)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Lead", style: UIAlertActionStyle.Default, handler: { action in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NewLeadVC") as! NewLeadVC
            self.showViewController(vc, sender: vc)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonShowLeads(sender: UIButton){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LeadsVC") as! LeadsVC
        self.showViewController(vc, sender: self)
    }
    
    @IBAction func buttonShowContacts(sender: UIButton){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsVC") as! ContactsVC
        showViewController(vc, sender: self)
    }
    
    @IBAction func buttonShowAccounts(sender: UIButton) {
        print("Clicked")
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AccountsVC") as! AccountsVC
        showViewController(vc, sender: nil)
        
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    
}