//
//  Accounts.swift
//  Semestralka
//
//  Created by Cyril on 18/04/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MagicalRecord
import PKHUD

@objc(Account)
class Account: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var email: String?
    @NSManaged var rating: Int32
    @NSManaged var category: String?
    @NSManaged var assignTo: String?
    @NSManaged var onServer: Bool
    @NSManaged var updateMethod: String?
}

class Accounts {
    
    var accounts = [Account]()
    var dictionary = [String:[Account]]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var headers: [String:String]
    var url: String = ""
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init() {
        let base64Credentials = appDelegate.keyChain.get("base64")!
        headers = ["Authorization": base64Credentials, "Accept": "application/json"]
        url = defaults.stringForKey("url")!
    }
    
    func loadAccounts() -> [String:[Account]] {
        print("loading accounts")
        Alamofire.request(.GET, "\(url)/accounts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success(let data):
                MagicalRecord.saveWithBlock({ (c) in
                    Account.MR_truncateAll()
                    self.accounts = [Account]()
                    let response = JSON(data)
                    for ( _, contactDetails):(String, JSON) in response {
                        for(_,details):(String, JSON) in contactDetails {
                            let id = Int32.init(details["id"].int!)
                            let name = details["name"].string
                            let phone = details["phone"].string
                            let email = details["email"].string
                            let rating = Int32.init(details["rating"].int!)
                            let assignTo = details["asssignTo"].string
                            let category = details["category"].string
                            let account = Account.MR_createEntityInContext(c)!
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
                        let accounts = Account.MR_findAll() as! [Account]
                        let dictionary = self.accountsToDict(accounts)
                        print("dict \(dictionary)")
                        self.appDelegate.currentAccounts = dictionary
                })
            case .Failure(let Error):
                self.dictionary = self.accountsToDict(Account.MR_findAll() as! [Account])
                self.appDelegate.currentAccounts = self.dictionary
                print("Request faild with error \(Error)")
                }
        }
        return dictionary
    }
    
    func accountsToDict(accounts: [Account]) -> [String:[Account]] {
        var dict = [String:[Account]]()
        for account in accounts {
            let name: String? = account.name
            if name != nil {
                let letter = String(Array(name!.capitalizedString.characters)[0])
                if dict[letter] != nil {
                    dict[letter]?.append(account)
                } else {
                    dict[letter] = [Account]()
                    dict[letter]?.append(account)
                }
            }
        }
        return dict
    }
    
    func createAccount(account: Account, accountsVC: AccountsVC?, newAccountVC: NewAccountVC? = nil) {
        let base64 = appDelegate.keyChain.get("base64")!
        let headers = ["Authorization": base64, "accept":"application/json"]
        let url = defaults.stringForKey("url")!
        let password = appDelegate.keyChain.get("password")!
        let userName = appDelegate.keyChain.get("userName")!
        print("createing account \(account)")
        var params = getParams(account, token: "")
        //Getting token first
        getToken { (token) in
            print("getting token: \(token)")
            if token != nil {
                HUD.flash(.Label("Creating Account..."), delay: 8.0, completion: { completed in
                    if completed {
                        HUD.flash(.Success, delay: 2.0)
                        accountsVC!.refreshTable()
                    }
                })
                params["authenticity_token"] = token
                Alamofire.request(.POST, "\(url)/accounts", headers: headers, parameters: params).authenticate(user:
                    userName, password: password)
                    .responseString { response in switch response.result{
                    case .Success( _):
                        print("success")
                        self.appDelegate.persistContext()
                    case .Failure( _): break
                        }
                }
            } else {
                print("coud not upload to server!")
                let alert = UIAlertController(title: "No internet connection!", message: "Do you want to post the account when you will be online?", preferredStyle: .Alert)
                let cancelButton = UIAlertAction(title: "No", style: .Default, handler: { action in
                    MagicalRecord.saveWithBlock({ (c) in
                        account.MR_deleteEntityInContext(c)
                        self.appDelegate.persistContext()
                    })
                })
                let yesButton = UIAlertAction(title: "Yes", style: .Default, handler: { action in
                    account.onServer = false
                    self.appDelegate.persistContext()
                    let dictionary = (accountsVC?.accountsToDict(Account.MR_findAll() as! [Account]))!
                    accountsVC?.accounts = dictionary
                    accountsVC?.sections = Array(dictionary.keys).sort()
                    accountsVC?.tableView.reloadData()
                })
                alert.addAction(yesButton)
                alert.addAction(cancelButton)
                newAccountVC!.showViewController(alert, sender: nil)
            }
        }
        
    }
    
    func updateAccount(account: Account, accountsVC: AccountsVC?, oldAccountParams: [String:AnyObject?]?, withUserNotification: Bool = true) {
        let base64 = appDelegate.keyChain.get("base64")!
        let headers = ["Authorization": base64, "accept":"application/json"]
        let url = defaults.stringForKey("url")!
        let id = account.id
        var params = self.getParams(account, token: "")
        print("updating \(account.name) to \(url) with \(params)")
        //Getting token first
        getToken { (token) in
            print("Token -> \(token)")
            if token != nil {
                params["authenticity_token"] = token!
                Alamofire.request(.PATCH, "\(url)/accounts/\(id)", headers: headers, parameters: params)
                    .responseString { response in switch response.result {
                    case .Success(let data):
                        if withUserNotification {
                            HUD.flash(.Label("Updating Account..."), delay: 5.0, completion: { completed in
                                accountsVC?.tableView?.reloadData()
                            })
                        }
                        print("Successfully connected: \(data)")
                    case .Failure( _): break
                        }
                }
            } else {
                let alert = UIAlertController.init(title: "Server is not reachable!", message: "Do you want to update account when you will be online?", preferredStyle: .Alert)
                let yesButton = UIAlertAction.init(title: "Yes", style: .Default, handler: { (action) in
                    print("saving account for later update")
                    account.onServer = false
                    account.updateMethod = "PATCH"
                    self.appDelegate.persistContext()
                    accountsVC!.refreshTable()
                })
                let noButton = UIAlertAction.init(title: "No", style: .Default, handler: { (action) in
                    account.onServer = true
                    account.assignTo = oldAccountParams!["assignTo"] as? String
                    account.email = oldAccountParams!["email"] as? String
                    account.phone = oldAccountParams!["phone"] as? String
                    account.name = oldAccountParams!["name"] as? String
                    self.appDelegate.persistContext()
                    accountsVC?.refreshTable()
                })
                alert.addAction(yesButton)
                alert.addAction(noButton)
                accountsVC?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    func removeAccount(account: Account) {
        let base64 = appDelegate.keyChain.get("base64")!
        let headers = ["Authorization": base64, "accept":"application/json"]
        let url = defaults.stringForKey("url")!
        print("removing \(account)")
        //Getting token first
        getToken() { token in
            if token != nil {
            let id = String(account.id)
            let params = ["authenticity_token":token!, "id":id]
            Alamofire.request(.DELETE, "\(url)/accounts/\(account.id)", headers: headers, parameters: params)
                .responseString { response in switch response.result {
                case .Success(let data):
                    print("successfull, messsage: \(data)")
                    account.MR_deleteEntity()
                    self.appDelegate.persistContext()
                case .Failure(let error):
                    print(error)
                    }
            }
            } else {
             HUD.flash(.LabeledError(title: "Could not connect to internet.", subtitle: ""), delay: 3.0)
            }
        }
    }
    
    func getToken(completion: (token: String?) -> Void) -> Void {
        Alamofire.request(.GET, "\(url)/accounts.html", headers: headers)
            .responseString { response in switch response.result {
            case .Success(let data):
                let splitData = data.componentsSeparatedByString("\n")
                var token = ""
                for line in splitData {
                    if line.containsString("csrf-token"){
                        token = line.substringWithRange(Range<String.Index>(start: line.startIndex.advancedBy(37), end: line.endIndex.advancedBy(-4)))
                    }
                }
                completion(token: token)
            case .Failure( _):
                print("could not greb token")
                completion(token: nil)
                }
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
    
}