////
////  AccountsVC.swift
////  Semestralka
////
////  Created by Cyril on 16/03/16.
////  Copyright © 2016 cyril. All rights reserved.
////
//

import UIKit

struct Account {
    let name: String
    let category: String
}

class AccountsVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tableView: UITableView!
    
    let textCellIdentifier = "Cell"
    var selectedAccount = ""
    let sections = ["A","B","C","D","E"]
    var accountsArray = [[Account(name: "Adam", category: "Customer")],[Account(name: "Bory", category: "Vendor"),Account(name: "Borek", category: "Reseller")],[Account(name: "Cyril", category: "Competitor"),Account(name: "Cecil",category: "Competitor")],[Account(name: "David",category: "Competitor"),Account(name: "Daniel", category: "Competitor")],[Account(name: "Eva", category: "Competitor")]]
    var filtered = [Account]()
    
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
        if (searchController.active){
            return nil
        }
        return self.sections[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (searchController.active) {
            return nil
        }
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.text = self.sections[section]
        cell.detailTextLabel?.text = nil
        cell.textLabel?.textAlignment = .Left
        cell.textLabel?.font = UIFont(name: "Avenir-Light" , size: 15)
        return cell
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
        return accountsArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if(searchController.active){
            cell.textLabel?.text = filtered[indexPath.row].category
            cell.detailTextLabel?.text = filtered[indexPath.row].name
        } else {
            cell.detailTextLabel?.text = accountsArray[indexPath.section][indexPath.row].name
            cell.textLabel?.text = accountsArray[indexPath.section][indexPath.row].category
        }
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light" , size: 20)
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AccountDetailVC") as! AccountDetailVC
        if (searchController.active) {
                print(filtered[indexPath.row])
            //self.showViewController(vc, sender: vc)
            searchController.dismissViewControllerAnimated(true, completion: {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }else {
            print(accountsArray[indexPath.section][indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filtered.removeAll(keepCapacity: false)
        filtered = accountsArray.flatten().filter({ (account) -> Bool in
            let tmp: NSString = account.name
            let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        print(filtered)
        self.tableView.reloadData()
    }
    
}
