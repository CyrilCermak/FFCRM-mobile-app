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
import Async
import AEXML

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
    var headers: [String:String]
    var url: String!
    var base64:String!
    let password:String!
    let userName:String!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        let base64 = appDelegate.keyChain.get("base64")!
        headers = ["Authorization": base64, "Accept": "application/json"]
        url = defaults.stringForKey("url")!
        password = appDelegate.keyChain.get("password")!
        userName = appDelegate.keyChain.get("userName")!
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
                            let account = Account.MR_createEntityInContext(c)!
                            account.id = Int32.init(details["id"].int!)
                            account.name = details["name"].string
                            account.phone = details["phone"].string
                            account.email = details["email"].string
                            account.rating = Int32.init(details["rating"].int!)
                            account.category = details["category"].string
                            account.assignTo = details["asssignTo"].string
                            account.onServer = true
                        }
                    }
                    }, completion: { (success:Bool, error:NSError?) in
                        let accounts = Account.MR_findAll() as! [Account]
                        let dictionary = self.accountsToDict(accounts)
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
    
    func createAccount(account: Account, accountsVC: AccountsVC?, newAccountVC: NewAccountVC? = nil) {
        print("createing account \(account)")
        var params = getParams(account, token: "")
        //Getting token
        getToken { (token) in
            print("getting token: \(token)")
            if token != nil {
                params["authenticity_token"] = token
                Alamofire.request(.POST, "\(self.url)/accounts", headers: self.headers, parameters: params).authenticate(user:
                    self.userName, password: self.password)
                    .responseString { response in switch response.result{
                    case .Success( _):
                        HUD.flash(.Success, delay: 2.0)
                        accountsVC!.refreshTable()
                        self.appDelegate.persistContext()
                    case .Failure( _):
                        HUD.flash(.Error, delay: 2.0)
                        }
                }
            } else {
                HUD.hide(afterDelay: 0.0)
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
    
    func updateAccount(account: Account, accountsVC: AccountsVC?, oldAccountParams: [String:AnyObject?]?) {
        let id = account.id
        var params = self.getParams(account, token: "")
        print("updating \(account.name) to \(url) with \(params)")
        //Getting token first
        getToken { (token) in
            print("Token -> \(token)")
            if token != nil {
                params["authenticity_token"] = token!
                Alamofire.request(.PATCH, "\(self.url)/accounts/\(id)", headers: self.headers, parameters: params)
                    .responseString { response in switch response.result {
                    case .Success(let data):
                        HUD.flash(.Success,delay: 2.0)
                        accountsVC?.tableView?.reloadData()
                        print("Successfully connected: \(data)")
                    case .Failure( _):
                        HUD.flash(.Error, delay: 2.0)
                        }
                }
            } else {
                HUD.flash(.Error, delay: 1.0, completion: { completed in
                    if completed {
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
                    
                })
            }
        }
    }
    
    func removeAccount(account: Account, accountsVC: AccountsVC?) {
        getToken() { token in
            if token != nil {
                let id = String(account.id)
                let params = ["authenticity_token":token!, "id":id]
                Alamofire.request(.DELETE, "\(self.url)/accounts/\(account.id)", headers: self.headers, parameters: params)
                    .responseString { response in switch response.result {
                    case .Success( _):
                        HUD.flash(.Success,delay: 2.0,completion: { completed in
                            self.appDelegate.persistContext()
                            account.MR_deleteEntity()
                            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion({ (completed, e) in
                                if completed {
                                    print("refreshing table")
                                    accountsVC!.refreshTable()
                                }
                            })
                            
                        })
                    case .Failure( _):
                        HUD.flash(.LabeledError(title: "Server Error", subtitle: ""))
                        }
                }
            } else {
                HUD.flash(.LabeledError(title: "Server Error", subtitle: ""), delay: 2.0)
            }
        }
    }
    
    
    
    
    
    func getToken(animated: Bool = true, completion: (token: String?) -> Void) -> Void {
        //Starting user notification about progress.
        if animated {
            HUD.show(.LabeledProgress(title: "Updating Server", subtitle: ""))
        }
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
    
    //MARK: UPDATE ON Server

    
    func updateServer(accountsForUpdate: [Account], completion:(completed: Int) -> Void ) {
        var i = 0
        getToken() { token in
            if token != nil {
                for account in accountsForUpdate {
                    let params = self.getParams(account, token: token!)
                    switch account.updateMethod! {
                    case "POST":
                        print("posting account")
                        Alamofire.request(.POST, "\(self.url)/accounts", headers: self.headers, parameters: params).authenticate(user:
                            self.userName, password: self.password)
                            .responseString { response in switch response.result{
                            case .Success( _):
                                print("posted \(i)")
                                i += 1
                                completion(completed: i)
                            case .Failure( _):
                                i += 1
                                completion(completed: i)
                                }
                        }
                    case "PATCH":
                        print("patching")
                        //TODO
                        Alamofire.request(.PATCH, "\(self.url)/accounts/\(account.id)", headers: self.headers, parameters: params)
                            .responseString { response in switch response.result {
                            case .Success( _):
                                print("patched \(i)")
                                i += 1
                                completion(completed: i)
                            case .Failure( _):
                                i += 1
                                completion(completed: i)
                                }
                        }
                    default: break
                    }
                }
            }
        }
        
    }
    
}