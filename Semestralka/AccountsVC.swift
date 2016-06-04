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
import MagicalRecord
import PKHUD
import Async

class AccountsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
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
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
    }
    
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
        print(accounts)
        sections = Array(accounts.keys).sort()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AccountsVC.refreshTable),
                                                         name: "refreshAccounts",object: nil)
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
        cell.backgroundColor = UIColor.init(red:0.037, green:0.777, blue:0.118, alpha:1.00)
        cell.textLabel?.text = self.sections[section]
        cell.detailTextLabel?.textColor = self.view.tintColor
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func buttonAddClicked(sender: AnyObject) {
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
            let account = filtered[indexPath.row]
            
            cell.textLabel?.text = account.name!
        } else {
            let account = accounts[sections[indexPath.section]]![indexPath.row]
            print(account)
            let name = account.name
            cell.textLabel?.text = name
        }
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light" , size: 20)
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (searchController.active) {
            print(filtered[indexPath.row])
            searchController.dismissViewControllerAnimated(true, completion: {
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAccountSegue" {
            print("AccountDetailSEGUEEEE")
            let accountDetailVC = segue.destinationViewController as! AccountDetailVC
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if self.searchController.active && filtered.count != 0 {
                    accountDetailVC.selectedAccount = filtered[indexPath.row]
                    searchController.dismissViewControllerAnimated(true, completion: {
                    })
                } else {
                    let account = accounts[sections[indexPath.section]]![indexPath.row]
                    print(account)
                    accountDetailVC.selectedAccount = account
                }
                accountDetailVC.accountsVC = self
            }
        }else if segue.identifier == "newAccountSegue" {
            let newAccountVC = segue.destinationViewController as! NewAccountVC
            newAccountVC.accountsVC = self
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
        print("refreshing table")
        let base64 = appDelegate.keyChain.get("base64")!
        let headers = ["Authorization": base64 ]
        let url = defaults.stringForKey("url")!
        var accountsA = [Account]()
        var dictionary = [String:[Account]]()
        Alamofire.request(.GET, "\(url)/accounts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success( _):
                self.syncWithDatabase() { completed in
                    if completed {
                        Alamofire.request(.GET, "\(url)/accounts.json", headers: headers, encoding:.JSON)
                            .responseJSON { response in switch response.result{
                            case .Success(let data):
                                print("Downloading data")
                                let response = JSON(data)
                                MagicalRecord.saveWithBlock({ (c) in
                                    Account.MR_truncateAllInContext(c)
                                    for ( _, accountDetails):(String, JSON) in response {
                                        for(_,details):(String, JSON) in accountDetails {
                                            let id = Int32.init(details["id"].int!)
                                            let name = details["name"].string
                                            let phone = details["phone"].string
                                            let email = details["email"].string
                                            let rating = Int32.init(details["rating"].int!)
                                            let assignTo = details["asssignTo"].string
                                            let category = details["category"].string
                                            let account:Account = Account.MR_createEntityInContext(c)!
                                            account.id = id
                                            account.name = name
                                            account.phone = phone
                                            account.email = email
                                            account.rating = rating
                                            account.category = category
                                            account.assignTo = assignTo
                                            account.onServer = true
                                        }
                                    }
                                    }, completion: { (success:Bool, error:NSError?) in
                                        accountsA = Account.MR_findAll() as! [Account]
                                        dictionary = self.accountsToDict(accountsA)
                                        self.appDelegate.persistContext()
                                        self.accounts = dictionary
                                        self.sections = Array(dictionary.keys).sort()
                                        self.appDelegate.currentAccounts = dictionary
                                        self.tableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                })
                            case .Failure( _): break
                                }
                                self.refreshControl.endRefreshing()
                        }
                    }
                }
            case .Failure( _):
                accountsA = Account.MR_findAll() as! [Account]
                print(accountsA)
                self.accounts = self.accountsToDict(accountsA)
                self.sections = Array(self.accounts.keys).sort()
                self.appDelegate.currentAccounts = self.accounts
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(title: "Faild to fetch data from Internet.", message: "Please check you network connection.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Destructive) { (action) in
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true){}
                
                }
        }
        
    }
    func syncWithDatabase(completion: (result: Bool) -> Void ) {
        self.refreshControl.endRefreshing()
        completion(result: false)
        let accountModel = Accounts()
        let accountsAll = Account.MR_findAll() as! [Account]
        var accountsForUpdate = [Account]()
        for account in accountsAll {
            if account.onServer == false {
                accountsForUpdate.append(account)
            }
        }
        if accountsForUpdate.count != 0 {
            HUD.show(.Progress)
            accountModel.updateServer(accountsForUpdate) { completed in
                if completed == accountsForUpdate.count {
                    HUD.hide()
                    HUD.flash(.Success,delay: 1.0)
                    completion(result: true)
                }
            }
        }else {
            completion(result: true)
        }
    }
    
    
    
    private func getParams(account: Account, token: String) -> [String: String] {
        var name: String {
            if let name = account.name {
                return name
            }
            return ""
        }
        var phone: String {
            if let phone = account.phone {
                return phone
            }
            return ""
        }
        var email: String {
            if let email = account.email {
                return email
            }
            return ""
        }
        var assignedTo: String {
            if let aT = account.assignTo {
                return aT
            }
            return ""
        }
        return ["account[name]": name,"account[assigned_to]":assignedTo ,"account[phone]": phone,"account[rating]": "\(account.rating)" ,"account[email]": email, "authenticity_token": token]
    }
    
    func accountsToDict(accounts: [Account]) -> [String:[Account]] {
        var dict = [String:[Account]]()
        for account in accounts {
            let name = account.name!
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
