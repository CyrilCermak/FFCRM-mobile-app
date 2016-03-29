//
//  FormsVC.swift
//  Semestralka
//
//  Created by Cyril on 23/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//
import UIKit
import Eureka

class FormsVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLoginForm(toForm: form)
        addPhoneForm(toForm: form)
    }
    
    private func addLoginForm(toForm form: Form) {
        form +++ Section("Login Form")
            <<< TextRow() { $0.placeholder = "Username" }
            <<< PasswordRow() { $0.placeholder = "Password"; $0.tag = "password"}
            <<< ButtonRow() {
                $0.title = "Login"
                $0.onCellSelection { cell, row in
                 print (form.values(includeHidden: true))
                }
        }
        
    }
    
    private func addPhoneForm(toForm form: Form){
        form +++ Section("Phone Form")
            <<< PhoneRow() { $0.placeholder = "Phone Number" }
            <<< ButtonRow() { $0.title = "Add"
                $0.onCellSelection { cell, row in }
                    }
        form +++ Section("Date and Time")
            <<< EmailRow() { $0.placeholder = "Email: " }
            <<< URLRow() { $0.placeholder = "URL" }
        

}
    
    
}
