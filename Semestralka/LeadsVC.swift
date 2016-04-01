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



class LeadsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tableView: UITableView!
    
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
        
        tableView.contentOffset = CGPoint.init(x: 0, y: 20)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK TableView Implementation
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (searchController.active) {
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
        if (searchController.active) {
            return filtered.count
        }
        return sections.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.active) {
            return filtered.count
        }
        return leadsArray[section].count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LeadDetailVC") as! LeadDetailVC
        if (searchController.active) {
            print(filtered[indexPath.row])
            searchController.dismissViewControllerAnimated(true, completion: {
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }else {
            print(leadsArray[indexPath.section][indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(tableView: UITableView,  titleForHeaderInSection section: Int) -> String? {
        if (searchController.active){
            return nil
        }
        return self.sections[section]
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        if (searchController.active){
            cell.textLabel?.text = filtered[indexPath.row].status
            cell.detailTextLabel?.text = filtered[indexPath.row].name
        } else {
            cell.textLabel?.text = leadsArray[indexPath.section][indexPath.row].status
            cell.detailTextLabel?.text = leadsArray[indexPath.section][indexPath.row].name
        }
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Light" , size: 20)
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filtered.removeAll(keepCapacity: false)
        filtered = leadsArray.flatten().filter({ (lead) -> Bool in
            let tmp: NSString = lead.name
            let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        print(filtered)
        self.tableView.reloadData()
    }
    
    
    
}
