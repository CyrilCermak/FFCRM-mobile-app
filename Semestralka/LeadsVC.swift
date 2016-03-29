//
//  LeadsVC.swift
//  Semestralka
//
//  Created by Cyril on 26/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

struct Lead {
    let name: String
    let status: String
    let phone: String? = nil
    let email: String? = nil
}



class LeadsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
 
    @IBOutlet var tableView: UITableView!
    var activeSearch: Bool = false
    var filtered = [Lead]()
    var sections = ["A","B","C","D","E"]
    var leadsArray = [[Lead(name: "Adam", status: "Customer")],
                      [Lead(name: "Bory", status: "Vendor"),Lead(name: "Borek", status: "Reseller")],
                      [Lead(name: "Cyril", status: "Competitor"),Lead(name: "Cecil",status: "Competitor")],
                      [Lead(name: "David",status: "Competitor"),Lead(name: "Daniel", status: "Competitor")],
                      [Lead(name: "Eva", status: "Competitor")]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Search Leads"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK SearchBar Implementation
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        activeSearch = false
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        activeSearch = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        activeSearch = false
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        activeSearch = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = leadsArray.flatten().filter({ (lead) -> Bool in
            let tmp: NSString = lead.name
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if (filtered.count == 0){
            activeSearch = false
        } else {
            activeSearch = true
        }
        self.tableView.reloadData()
    }
    
    // MARK TableView Implementation
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (activeSearch) {
            return nil
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.text = self.sections[section]
        cell.detailTextLabel?.text = nil
        cell.textLabel?.textAlignment = .Left
        cell.textLabel?.font = UIFont(name: "Avenir-Light" , size: 15)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (activeSearch) {
            return 1
        }
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (activeSearch) {
            return filtered.count
        }
        return leadsArray[section].count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (activeSearch) {
            print(filtered[indexPath.row])
        } else {
            print(leadsArray[indexPath.section][indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (activeSearch) {
            return nil
        }
        return sections[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if (activeSearch){
            cell.textLabel?.text = filtered[indexPath.row].status
            cell.detailTextLabel?.text = filtered[indexPath.row].name
        } else {
        cell.textLabel?.text = leadsArray[indexPath.section][indexPath.row].status
        cell.detailTextLabel?.text = leadsArray[indexPath.section][indexPath.row].name
    }
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light" , size: 20)
        return cell
    }
    
    
}
