//: Playground - noun: a place where people can play

import UIKit
import Contacts
var str = "Hello, playground"
print(str)
struct Contact {
    var id: Int?
    var first_name: String!
    var last_name: String
    var department: String
    var phone: String? = nil
    var mobile: String? = nil
    var email: String? = nil
    var assignTo: Int? = nil
}

print(str.characters.first)

var contacts = [Contact(id: 1,first_name: "Cyril",last_name: "Ceramk",department: "Department", phone: "123456789", mobile: "012345566",email: "cyril@gmail.com", assignTo: 1) ,Contact(id: 1,first_name: "Lukas",last_name: "Ceramk",department: "Department", phone: "123456789", mobile: "012345566",email: "cyril@gmail.com", assignTo: 1)]

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

dict.count

Array(dict.keys).sort()

Array(dict.values.flatten())
    
