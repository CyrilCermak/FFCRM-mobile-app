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
import KeychainSwift
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isLoggedIn = false
    var menuShowed = true
    
    var currentContacts = [String:[Contact]]()
    var currentAccounts = [String:[Account]]()
    var currentLeads = [String:[Lead]]()
    var contactsRefreshed = false
    let defaults = NSUserDefaults.standardUserDefaults()
    var keyChain = KeychainSwift()
    
    func createCredentials() {
        let password = keyChain.get("password")!
        let userName = keyChain.get("userName")!
        print(password)
        let credentialData = "\(userName):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let pass = "Basic \(base64Credentials)"
        keyChain.set(pass, forKey: "base64")
        isLoggedIn = true
        Accounts().loadAccounts()
        Contacts().loadContacts()
    }
    
    func setupMagicalRecord() -> Void {
        MagicalRecord.enableShorthandMethods()
        MagicalRecord.setupAutoMigratingCoreDataStack();
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setAppearance()
//        keyChain.set("a",forKey: "password")
//        keyChain.set("cyril",forKey: "userName")
//        defaults.setValue("http://localhost:3000", forKey: "url")
        setupMagicalRecord()
        return true
    }
    
    func setAppearance() -> Void {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().backgroundColor = UIColor.init(red:0.037, green:0.777, blue:0.118, alpha:1.00)
        UINavigationBar.appearance().opaque = false
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = UIColor.init(red:0.037, green:0.777, blue:0.118, alpha:1.00)
        UIApplication.sharedApplication()

        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 24)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        
    }
    
    func persistContext() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func getAccounts() -> [String:[Account]] {
        let acc = Accounts().accountsToDict(Account.MR_findAll() as! [Account])
        print("Getting \(acc)")
        return acc
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


