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
    func loadContacts() -> [String:[Contact]] {
        let base64Credentials = defaults.stringForKey("base64")!
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        let url = defaults.stringForKey("url")!
        Alamofire.request(.GET, "\(url)/contacts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success(let data):
                self.contacts = [Contact]()
                let response = JSON(data)
                for (key, contactDetails):(String, JSON) in response {
                    print(key)
                    print(contactDetails)
                    for(_,details):(String, JSON) in contactDetails {
                        let id = Int.init(details["user_id"].int!)
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
    

}
