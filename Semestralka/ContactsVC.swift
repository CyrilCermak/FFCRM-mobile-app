//
//  ContactsVC.swift
//  Semestralka
//
//  Created by Cyril on 21/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
//Contact represents object of Contact

class ContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate,
UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var tableView: UITableView!
    var sections = [String]()
    var contacts = [String:[Contact]]()
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedContact = Contact()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var filtered = [Contact]()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentOffset = CGPoint.init(x: 0, y: 20)
        tableView.backgroundView?.backgroundColor = UIColor.whiteColor()
        tableView.backgroundColor = UIColor.whiteColor()
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
//
        // set style to navigation controller
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        //Load Data
        contacts = appDelegate.getContacts()
        sections = Array(contacts.keys).sort()
        
        //UIRefreshControl
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundView?.backgroundColor = UIColor.whiteColor()
        self.view.superview?.backgroundColor = UIColor.whiteColor()
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(ContactsVC.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(self.refreshControl) // not required when using UITableViewController
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func dispatchData(){
        self.tableView?.reloadData()
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
        return contacts[sections[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if(searchController.active){
            let firstName = filtered[indexPath.row].first_name!
            let lastName = filtered[indexPath.row].last_name!
            cell.textLabel?.text = "\(firstName) \(lastName)"
            cell.detailTextLabel?.text = filtered[indexPath.row].department
        } else {
            let firstName = contacts[sections[indexPath.section]]![indexPath.row].first_name
            let lastName = contacts[sections[indexPath.section]]![indexPath.row].last_name
            cell.textLabel?.text = "\(firstName) \(lastName)"
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
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContactsDetailVC") as! ContactsDetailVC
        if (searchController.active) {
            if (filtered.count != 0) {
                print(filtered[indexPath.row])
            }
        }else {
            print(contacts[sections[indexPath.section]]![indexPath.row])
            selectedContact = contacts[sections[indexPath.section]]![indexPath.row]
        }
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filtered.removeAll(keepCapacity: false)
        filtered = Array(contacts.values.flatten()).filter({ (contact) -> Bool in
            let tmp: NSString = "\(contact.first_name!) \(contact.last_name!)"
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
    
    func refreshTable() {
        let base64 = defaults.stringForKey("base64")!
        let headers = ["Authorization": base64 ]
        let url = defaults.stringForKey("url")!
        var dictionary = [String:[Contact]]()
        var contactsArray = [Contact]()
        
        Alamofire.request(.GET, "\(url)/contacts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success(let data):
                let response = JSON(data)
                for (key, contactDetails):(String, JSON) in response {
                    print(key)
                    print(contactDetails)
                    for(_,details):(String, JSON) in contactDetails {
                        let id = Int.init(details["user_id"].int!)
                        let assignTo = details["assigned_to"].int
                        let first_name = details["first_name"].string
                        let last_name = details["last_name"].string
                        let department = details["department"].string
                        let phone = details["phone"].string
                        let mobile = details["mobile"].string
                        let email = details["email"].string
                        let contact = Contact(id: id,first_name: first_name,last_name: last_name,department: department, phone: phone, mobile: mobile,email: email, assignTo: assignTo)
                        contactsArray.append(contact)
                    }
                }
                dictionary = self.contactsToDict(contactsArray)
                print(dictionary)
                self.contacts = dictionary
                self.sections = Array(dictionary.keys).sort()
                self.appDelegate.currentContacts = dictionary
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            case .Failure( _):
                self.refreshControl.endRefreshing()
                let alertController = UIAlertController(title: "Faild to fetch data.", message: "Please check you network connection.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Destructive) { (action) in
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true){}
                }
        }
    }
    
    func contactsToDict(contacts: [Contact]) -> [String:[Contact]] {
        var dict = [String:[Contact]]()
        for contact in contacts {
            let name: String = contact.first_name
            let letter = String(Array(name.capitalizedString.characters)[0])
            if dict[letter] != nil {
                dict[letter]?.append(contact)
            } else {
                dict[letter] = [Contact]()
                dict[letter]?.append(contact)
            }
        }
        print(dict)
        return dict
        
    }
    
    
    
}
