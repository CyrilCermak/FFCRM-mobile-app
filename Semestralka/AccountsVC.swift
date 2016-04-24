////
////  AccountsVC.swift
////  Semestralka
////
////  Created by Cyril on 16/03/16.
////  Copyright © 2016 cyril. All rights reserved.
////
//

import UIKit
import Alamofire
import SwiftyJSON

class AccountsVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tableView: UITableView!
    
    let textCellIdentifier = "Cell"
    var selectedAccount = ""
    var sections = [String]()
    var accounts = [String:[Account]]()
    var filtered = [Account]()
    var refreshControl: UIRefreshControl!
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentOffset = CGPoint.init(x: 0, y: 20)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        //loading data
        accounts = appDelegate.getAccounts()
        sections = Array(accounts.keys).sort()
        
        // set style to navigation controller
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 20)!]
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        //UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AccountsVC.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.whiteColor()
        tableView.addSubview(self.refreshControl)
        
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (searchController.active) {
            return nil
        }
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.text = self.sections[section]
        cell.detailTextLabel?.textColor = self.view.tintColor
        cell.textLabel?.textColor = self.view.tintColor
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchController.active){
            return nil
        }
        return self.sections[section]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (searchController.active) {
            return filtered.count
        }
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.active) {
            return filtered.count
        }
        return accounts[sections[section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! 
        if(searchController.active){
            cell.textLabel?.text = filtered[indexPath.row].name
            //            cell.detailTextLabel?.text = filtered[indexPath.row].name
        } else {
            cell.textLabel?.text = accounts[sections[indexPath.section]]![indexPath.row].name
        }
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light" , size: 20)
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AccountDetailVC") as! AccountDetailVC
        if (searchController.active) {
            print(filtered[indexPath.row])
            //self.showViewController(vc, sender: vc)
            searchController.dismissViewControllerAnimated(true, completion: {
                //                self.navigationController?.pushViewController(vc, animated: true)
            })
        }else {
            //            print(accountsArray[sections[section]][indexPath.row])
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAccountSegue" {
            print("AccountDetailSEGUEEEE")
            let accountDetailVC = segue.destinationViewController as! AccountDetailVC
            //            let accountDetailVC = navController.topViewController as! AccountDetailVC
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if self.searchController.active && filtered.count != 0 {
                    accountDetailVC.selectedAccount = filtered[indexPath.row]
                    searchController.dismissViewControllerAnimated(true, completion: {
                    })
                } else {
                    accountDetailVC.selectedAccount = accounts[sections[indexPath.section]]![indexPath.row]
                }
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filtered.removeAll(keepCapacity: false)
        filtered = accounts.values.flatten().filter({ (account) -> Bool in
            let tmp: NSString = account.name!
            let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        print(filtered)
        self.tableView.reloadData()
    }
    
    func getStars(num: Int) -> String {
        var x = 1
        var stars = ""
        while x < num {
            stars.appendContentsOf("*")
            x = x + 1
        }
        return stars
    }
    
    func refreshTable() {
        let base64 = defaults.stringForKey("base64")!
        let headers = ["Authorization": base64 ]
        let url = defaults.stringForKey("url")!
        var accountsA = [Account]()
        var dictionary = [String:[Account]]()
        Alamofire.request(.GET, "\(url)/accounts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success(let data):
                let response = JSON(data)
                for (key, contactDetails):(String, JSON) in response {
                    print(key)
                    print(contactDetails)
                    for(_,details):(String, JSON) in contactDetails {
                        let id = Int.init(details["id"].int!)
                        let name = details["name"].string
                        let phone = details["phone"].string
                        let email = details["email"].string
                        let rating = Int.init(details["rating"].int!)
                        let assignTo = details["asssignTo"].string
                        let category = details["category"].string
                        let account = Account(id: id,name: name,phone: phone, email: email, rating: rating, category: category, assignTo: assignTo)
                        accountsA.append(account)
                    }
                }
                dictionary = self.contactsToDict(accountsA)
                self.accounts = dictionary
                self.sections = Array(dictionary.keys).sort()
                self.appDelegate.currentAccounts = dictionary
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
    
    func contactsToDict(accounts: [Account]) -> [String:[Account]] {
        var dict = [String:[Account]]()
        for account in accounts {
            let name: String = account.name!
            let letter = String(Array(name.capitalizedString.characters)[0])
            if dict[letter] != nil {
                dict[letter]?.append(account)
            } else {
                dict[letter] = [Account]()
                dict[letter]?.append(account)
            }
        }
        return dict
    }
    
}
