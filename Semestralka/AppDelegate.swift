//
//  AppDelegate.swift
//  Semestralka
//
//  Created by Cyril on 09/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isLoggedIn = false
    var menuShowed = true
    var contacts = Contacts()
    var accounts = Accounts()
    var currentContacts = [String:[Contact]]()
    var currentAccounts = [String:[Account]]()
    var currentLeads = [String:[Lead]]()
    var contactsRefreshed = false
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func createCredentials() {
        let password = defaults.stringForKey("password")!
        let userName = defaults.stringForKey("userName")!
        let credentialData = "\(userName):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let pass = "Basic \(base64Credentials)"
        defaults.setValue(pass, forKeyPath: "base64")
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if (isLoggedIn){
            currentContacts = contacts.loadContacts()
            currentAccounts = accounts.loadContacts()
        }
        defaults.setValue("password", forKeyPath: "cyril")
        defaults.setValue("userName", forKeyPath: "a")
        defaults.setValue("url", forKeyPath: "http://localhost:3000")
        return true
    }
    
    func prepareData() {
        currentContacts = contacts.loadContacts()
        currentAccounts = accounts.loadContacts()
    }
    
    func getAccounts() -> [String:[Account]] {
        return currentAccounts
    }
    
    func getContacts() -> [String:[Contact]] {
        return currentContacts
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

