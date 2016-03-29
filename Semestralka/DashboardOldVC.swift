//
//  DashboardVCViewController.swift
//  Semestralka
//
//  Created by Cyril on 15/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

class DashboardOldVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    let data = [["Show All","Create"],["Show All","Create"],["Show All","Create"]]
    let sections = ["Accounts","Contacts","Leads"]
   
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        //COMENT LINE TO ENABLE USER LOGIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        appDelegate.isLoggedIn = true
        if (appDelegate.isLoggedIn == false){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let login = storyboard.instantiateViewControllerWithIdentifier("loginNavigationController")
            login.modalTransitionStyle = .CoverVertical
            presentViewController(login, animated: true, completion: nil)
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = UIColor.blueColor()
        cell.textLabel?.text = self.sections[section]
        return cell

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.data[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.data[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
