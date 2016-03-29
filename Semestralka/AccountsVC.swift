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

class AccountsVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    let textCellIdentifier = "Cell"
    var selectedAccount = ""
    let sections = ["A","B","C","D","E"]
    var accountsArray = [[Account(name: "Adam", category: "Customer")],[Account(name: "Bory", category: "Vendor"),Account(name: "Borek", category: "Reseller")],[Account(name: "Cyril", category: "Competitor"),Account(name: "Cecil",category: "Competitor")],[Account(name: "David",category: "Competitor"),Account(name: "Daniel", category: "Competitor")],[Account(name: "Eva", category: "Competitor")]]
    var filtered = [Account]()
    var searchActive: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Search Accounts"
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
        if (searchActive){
            return nil
        }
        return self.sections[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (searchActive) {
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = accountsArray.flatten().filter({ (account) -> Bool in
            let tmp: NSString = account.name
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (searchActive) {
            return 1
        }
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return accountsArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if(searchActive){
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
        if (searchActive) {
            if (filtered.count != 0) {
                print(filtered[indexPath.row])
                searchActive = false
            }
        }else {
            print(accountsArray[indexPath.section][indexPath.row])
        }
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AccountDetailVC") as! AccountDetailVC
        self.showViewController(vc, sender: vc)
    }
    
}
