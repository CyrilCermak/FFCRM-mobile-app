//
//  ContactsVC.swift
//  Semestralka
//
//  Created by Cyril on 21/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

//Contact represents object of Contact
struct Contact {
    let name: String
    let position: String
    let phone: String? = nil
    let mobile: String? = nil
    let email: String? = nil
    let other: String? = nil
    let assignTo: String? = nil 
    
}


class ContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,
UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var tableView: UITableView!
    
    let sections = ["A","B","C","D","E"]
    var contactsArray = [[Contact(name: "Adam", position: "Driver")],[Contact(name: "Bory", position: "Programmer"),Contact(name: "Borek", position: "Cleaner")],[Contact(name: "Cyril",position: "Programmer"),Contact(name: "Cecil", position: "House cleaner")],[Contact(name: "David", position: "None"),Contact(name: "Daniel", position: "Driver")],[Contact(name: "Eva", position: "Prostitute")]]
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
        return contactsArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if(searchController.active){
            cell.textLabel?.text = filtered[indexPath.row].name
        } else {
            cell.textLabel?.text = contactsArray[indexPath.section][indexPath.row].name
            cell.detailTextLabel?.text = contactsArray[indexPath.section][indexPath.row].position
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
                searchController.dismissViewControllerAnimated(true, completion: {
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }else {
            print(contactsArray[indexPath.section][indexPath.row])
            self.showViewController(vc, sender: vc)
        }
        
    }

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filtered.removeAll(keepCapacity: false)
        filtered = contactsArray.flatten().filter({ (contact) -> Bool in
            let tmp: NSString = contact.name
            let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        print(filtered)
        self.tableView.reloadData()
    }
    
    
}
