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

struct Account {
    var id: Int!
    var name: String? = nil
    var phone: String? = nil
    var email: String? = nil
    var rating: Int!
    var category: String? = nil 
    var assignTo: String? = nil
}


class Accounts {
    
    var accounts = [Account]()
    var dictionary = [String:[Account]]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var headers: [String:String]
    var url: String = ""
    
    init() {
        let base64Credentials = defaults.stringForKey("base64")!
        headers = ["Authorization": base64Credentials, "Accept": "application/json"]
        url = defaults.stringForKey("url")!
    }
    
    func loadContacts() -> [String:[Account]] {
        
        
        Alamofire.request(.GET, "\(url)/accounts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success(let data):
                self.accounts = [Account]()
                let response = JSON(data)
                for (key, contactDetails):(String, JSON) in response {
                    print(key)
                    print(contactDetails)
                    for(_,details):(String, JSON) in contactDetails {
                        let id = Int.init(details["id"].int!)
                        let name = details["name"].string
                        let phone = details["phone"].string
                        let email = details["email"].string
                        let rating = Int.init(details["rating"].int!)
                        let assignTo = details["asssignTo"].string
                        let category = details["category"].string
                        let account = Account(id: id,name: name,phone: phone, email: email, rating: rating,category: category, assignTo: assignTo)
                        self.accounts.append(account)
                    }
                }
                self.dictionary = self.contactsToDict(self.accounts)
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.currentAccounts = self.dictionary
                print(self.dictionary)
            case .Failure(let Error):
                print("Request faild with error \(Error)")
                }
        }
        return dictionary
    }
    
    func contactsToDict(accounts: [Account]) -> [String:[Account]] {
        var dict = [String:[Account]]()
        for account in accounts {
            let name: String = account.name!
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
    
    func createAccount(account: Account) {
        let base64 = defaults.stringForKey("base64")!
        let headers = ["Authorization": base64, "accept":"application/json"]
        let url = defaults.stringForKey("url")!
        print("createing account \(account)")
        //Getting token first
        Alamofire.request(.GET, "\(url)/accounts.html", headers: headers)
            .responseString { response in switch response.result {
            case .Success(let data):
                let splitData = data.componentsSeparatedByString("\n")
                var token = ""
                for line in splitData {
                    if line.containsString("csrf-token"){
                        print(line)
                        token = line.substringWithRange(Range<String.Index>(start: line.startIndex.advancedBy(37), end: line.endIndex.advancedBy(-4)))
                    }
                }
                print(token)
                self.postAccount(token, account: account)
            case .Failure(let error):
                print(error)
                
                }
        }
    }
    
   private func postAccount(token: String, account: Account) {
    let params = getParams(account, token: token)
        Alamofire.request(.POST, "\(url)/accounts.json", headers: headers, parameters: params).authenticate(user: "cyril", password: "a")
            .responseString { response in switch response.result{
            case .Success(let data):
                print("success")
                print(data)
            case .Failure(let error):
                print("error\(error)")
                }
        }
    }
    
    
    func updateAccount(account: Account) {
        //Getting Token
        let base64 = defaults.stringForKey("base64")!
        let headers = ["Authorization": base64, "accept":"application/json"]
        let url = defaults.stringForKey("url")!
        //Getting token first
        Alamofire.request(.GET, "\(url)/accounts.html", headers: headers)
            .responseString { response in switch response.result {
            case .Success(let data):
                let splitData = data.componentsSeparatedByString("\n")
                var token = ""
                for line in splitData {
                    if line.containsString("csrf-token"){
                        print(line)
                        token = line.substringWithRange(Range<String.Index>(start: line.startIndex.advancedBy(37), end: line.endIndex.advancedBy(-4)))
                    }
                }
                print(token)
                self.patchAccount(token, account: account)
            case .Failure(let error):
                print(error)
                
                }
        }
    }
    
    func patchAccount(token: String, account: Account) {
        print("patchin Account \(account)")
        let params = getParams(account, token: token)
        Alamofire.request(.PATCH, "\(url)/accounts/\(account.id)", headers: headers, parameters: params)
            .responseString { response in switch response.result {
            case .Success(let data):
                print("success")
                print(data)
            case .Failure(let error):
                print("error\(error)")
                }
        }
    }
    
    func removeAccount(account: Account) {
        let base64 = defaults.stringForKey("base64")!
        let headers = ["Authorization": base64, "accept":"application/json"]
        let url = defaults.stringForKey("url")!
        print("removing \(account)")
        //Getting token first
        Alamofire.request(.GET, "\(url)/accounts.html", headers: headers)
            .responseString { response in switch response.result {
            case .Success(let data):
                let splitData = data.componentsSeparatedByString("\n")
                var token = ""
                for line in splitData {
                    if line.containsString("csrf-token"){
                        print(line)
                        token = line.substringWithRange(Range<String.Index>(start: line.startIndex.advancedBy(37), end: line.endIndex.advancedBy(-4)))
                    }
                }
                print(token)
                self.deleteAccount(token, account: account)
            case .Failure(let error):
                print(error)
                
                }
        }
        
    }
    
    private func deleteAccount(token: String, account: Account) {
        let params = ["authenticity_token":token]
        Alamofire.request(.DELETE, "\(url)/accounts/\(account.id!)", headers: headers, parameters: params)
            .responseString { response in switch response.result {
            case .Success(let data):
                print(data)
                print("success")
            case .Failure(let error):
                print(error)
                
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
        return ["account[name]": name,"account[assigned_to]":assignedTo ,"account[phone]": phone,"account[rating]": "\(account.rating)" ,"account[email]": email, "authenticity_token": token ]
    }
    
}