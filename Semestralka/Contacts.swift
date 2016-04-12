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
    
    func loadContacts(){
        
        let user = "cyril"
        let password = "a"
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.GET, "http://localhost:3000/contacts.json", headers: headers, encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success(let data):
                let response = JSON(data)
                for (key, contactDetails):(String, JSON) in response {
                    print(key)
                    print(contactDetails)
                    for(contact,details):(String, JSON) in contactDetails {
                        print("asssigned_to")
                        print(details["assigned_to"])
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
            case .Failure(let Error):
                print("Request faild with error \(Error)")
                }
        }
    }
    
    func contactsToDict() -> [String:[Contact]] {
        var dict = [String:[Contact]]()
        for contact in contacts {
            let name: String = contact.first_name
            let letter = String(Array(name.capitalizedString.characters)[0])
            if dict[letter] != nil {
                dict[letter]?.append(contact)
            } else {
                dict[letter] = [Contact]()
                dict[letter]?.append(contact)
            }
        }
        print(dict)
        return dict
    }
}


























