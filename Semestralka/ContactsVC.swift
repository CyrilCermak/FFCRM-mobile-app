//
//  ContactsVC.swift
//  Semestralka
//
//  Created by Cyril on 21/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

//Contact represents object of Contact

class ContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,
UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var tableView: UITableView!
    
    var sections = [String]()
    var contacts = [String:[Contact]]()
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedContact = Contact()
    
    var filtered = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentOffset = CGPoint.init(x: 0, y: 20)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        // set style to navigation controller
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        //Load Data
        contacts = appDelegate.getContacts()
        sections = Array(contacts.keys).sort()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchController.active) {
            return nil
        } else {
            return self.sections[section]
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (searchController.active) {
            return nil
        }
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.text = self.sections[section]
        cell.detailTextLabel?.text = nil
        cell.textLabel?.textColor = self.view.tintColor
        return cell
    }
    
    func refresh(sender: AnyObject){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (searchController.active) {
            return 1
        }
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active) {
            return filtered.count
        }
        return contacts[sections[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if(searchController.active){
            cell.textLabel?.text = filtered[indexPath.row].first_name
            cell.detailTextLabel?.text = filtered[indexPath.row].department
        } else {
            cell.textLabel?.text = contacts[sections[indexPath.section]]![indexPath.row].first_name
            cell.detailTextLabel?.text = contacts[sections[indexPath.section]]![indexPath.row].department
        }
        cell.textLabel?.font = UIFont(name: "Avenir-Light" , size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light" , size: 15)
        cell.detailTextLabel?.textColor = self.view.tintColor
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsDetailVC") as! ContactsDetailVC
        if (searchController.active) {
            if (filtered.count != 0) {
                print(filtered[indexPath.row])
                //                searchController.dismissViewControllerAnimated(true, completion: {
                //                    self.navigationController?.pushViewController(vc, animated: true)
                //                })
            }
        }else {
            print(contacts[sections[indexPath.section]]![indexPath.row])
            selectedContact = contacts[sections[indexPath.section]]![indexPath.row]
        }
        
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filtered.removeAll(keepCapacity: false)
        filtered = Array(contacts.values.flatten()).filter({ (contact) -> Bool in
            let tmp: NSString = contact.first_name!
            let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        print(filtered)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ContactDetailSegue" {
            print("SEEEEGUUUUUUE")
            let contactsVC = segue.destinationViewController as! ContactsDetailVC
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if self.searchController.active && filtered.count != 0 {
                    contactsVC.contact = filtered[indexPath.row]
                    searchController.dismissViewControllerAnimated(true, completion: {
                    })
                } else {
                    contactsVC.contact = contacts[sections[indexPath.section]]![indexPath.row]
                }
            }
        }
    }
    
}
