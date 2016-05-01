//
//  Contact.swift
//  Semestralka
//
//  Created by Cyril on 11/04/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Contact {
    var id: Int?
    var first_name: String!
    var last_name: String!
    var department: String? = nil
    var phone: String? = nil
    var mobile: String? = nil
    var email: String? = nil
    var assignTo: Int? = nil
}

class Contacts {

    var contacts = [Contact]()
    var dictionary = [String:[Contact]]()
    let defaults = NSUserDefaults.standardUserDefaults()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let url: String
    let headers: [String:String]
   
    init() {
        let base64Credentials = appDelegate.keyChain.get("base64")!
        headers = ["Authorization": base64Credentials, "Accept": "application/json"]
        url = defaults.stringForKey("url")!
    }
    
    func loadContacts() -> [String:[Contact]] {
        let url = defaults.stringForKey("url")!
        
        Alamofire.request(.GET, "\(url)/contacts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success(let data):
                self.contacts = [Contact]()
                let response = JSON(data)
                for (key, contactDetails):(String, JSON) in response {
//                    print(key)
//                    print(contactDetails)
                    for(_,details):(String, JSON) in contactDetails {
                        let id = Int.init(details["id"].int!)
                        let assignTo = details["assigned_to"].int
                        let first_name = details["first_name"].string
                        let last_name = details["last_name"].string
                        let department = details["department"].string
                        let phone = details["phone"].string
                        let mobile = details["mobile"].string
                        let email = details["email"].string
                        let contact = Contact(id: id,first_name: first_name,last_name: last_name,department: department, phone: phone, mobile: mobile,email: email, assignTo: assignTo)
                        self.contacts.append(contact)
                    }
                }
                self.dictionary = self.contactsToDict(self.contacts)
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.currentContacts = self.dictionary
            case .Failure(let Error):
                print("Request faild with error \(Error)")
                }
        }
        return dictionary
    }
    
    
    
    func createContact(contact: Contact) {
        
        print("createing account \(contact)")
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
                self.postContact(token, contact: contact)
            case .Failure(let error):
                print(error)
                
                }
        }
    }
    
    
    private func postContact(token: String, contact: Contact){
        let params = getParams(contact, token: token)
        Alamofire.request(.POST, "\(url)/contacts.json", headers: headers, parameters: params).authenticate(user: "cyril", password: "a")
            .responseString { response in switch response.result{
            case .Success(let data):
                print("success")
//                print(data)
            case .Failure(let error):
                print("error\(error)")
                }
        }
    }

    func updateContact(contact: Contact) {
        //Getting Token
        let base64 = appDelegate.keyChain.get("base64")!
        let headers = ["Authorization": base64, "accept":"application/json"]
        let url = defaults.stringForKey("url")!
        //Getting token first
        Alamofire.request(.GET, "\(url)/contacts.html", headers: headers)
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
                self.patchContact(token, contact: contact)
            case .Failure(let error):
                print(error)
                
                }
        }
    }
    
    func patchContact(token: String, contact: Contact) {
        print("patchin Account \(contact)")
        let params = getParams(contact, token: token)
        Alamofire.request(.PATCH, "\(url)/contacts/\(contact.id!).json", headers: headers, parameters: params)
            .responseString { response in switch response.result {
            case .Success(let data):
                print("success")
//                print(data)
            case .Failure(let error):
                print("error\(error)")
                }
        }
    }
    
    func removeContact(contact: Contact) {
        Alamofire.request(.GET, "\(url)/contacts.html", headers: headers)
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
                self.deleteContact(token, contact: contact)
            case .Failure(let error):
                print(error)
                
                }
        }
    }
    
    private func deleteContact(token: String, contact: Contact) {
        let params = getParams(contact, token: token)
        Alamofire.request(.DELETE, "\(url)/contacts/\(contact.id!)", headers: headers, parameters: params)
            .responseString { response in switch response.result {
            case .Success(let data):
                print("success")
//                print(data)
            case .Failure(let error):
                print("error\(error)")
                }
        }
    }
    
    func contactsToDict(contacts: [Contact]) -> [String:[Contact]] {
        var dict = [String:[Contact]]()
        for contact in self.contacts {
            let name: String = contact.first_name
            let letter = String(Array(name.capitalizedString.characters)[0])
            if dict[letter] != nil {
                dict[letter]?.append(contact)
            } else {
                dict[letter] = [Contact]()
                dict[letter]?.append(contact)
            }
        }
        return dict
    }
    
    
    private func getParams(contact: Contact, token: String) -> [String: String] {
        var first_name: String {
            if let first_name = contact.first_name {
                return first_name
            }
            return ""
        }
        var last_name: String {
            if let last_name = contact.last_name {
                return last_name
            }
            return ""
        }
        var phone: String {
            if let phone = contact.phone {
                return phone
            }
            return ""
        }
        var email: String {
            if let email = contact.email {
                return email
            }
            return ""
        }
        var mobile: String {
            if let mobile = contact.mobile {
                return mobile
            }
            return ""
        }
        return ["contact[first_name]": first_name,"contact[last_name]": last_name ,"contact[phone]": phone, "account[id]":"" ,"contact[email]": email,"contact[mobile]": mobile, "authenticity_token": token ]
    }
}
