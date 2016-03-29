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
UISearchBarDelegate {
    
  
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    let sections = ["A","B","C","D","E"]
    var contactsArray = [[Contact(name: "Adam", position: "Driver")],[Contact(name: "Bory", position: "Programmer"),Contact(name: "Borek", position: "Cleaner")],[Contact(name: "Cyril",position: "Programmer"),Contact(name: "Cecil", position: "House cleaner")],[Contact(name: "David", position: "None"),Contact(name: "Daniel", position: "Driver")],[Contact(name: "Eva", position: "Prostitute")]]
    var filtered = [Contact]()
    var searchActive: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Search Contacts"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchActive) {
            return nil
        } else {
            return self.sections[section]
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (searchActive) {
            return nil
        }
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.text = self.sections[section]
        cell.detailTextLabel?.text = nil
        cell.textLabel?.textColor = self.view.tintColor
        return cell
    }
    
    //MARK: UISearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = contactsArray.flatten().filter({ (contact) -> Bool in
            let tmp: NSString = contact.name
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if (filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (searchActive) {
            return 1
        }
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            filtered.count
        }
        return contactsArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if(searchActive){
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
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (searchActive) {
            if (filtered.count != 0) {
                print(filtered[indexPath.row])
                searchActive = false
            }
        }else {
            print(contactsArray[indexPath.section][indexPath.row])
        }
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsDetailVC") as! ContactsDetailVC
        self.showViewController(vc, sender: vc)
    }

}
