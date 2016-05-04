//
//  ViewController.swift
//  Semestralka
//
//  Created by Cyril on 09/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import Alamofire
import Eureka
import KeychainSwift
import PKHUD

class LoginVC : FormViewController {
    
    
    var nameRow: TextRow!
    let defaults = NSUserDefaults.standardUserDefaults()
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.backgroundColor = UIColor.whiteColor()
        addForms(toForm: form)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameRow.cell?.becomeFirstResponder()
        nameRow.cell?.textField.selectAll(nameRow.cell)
    }
    
    @IBAction func buttonConnectClicked(sender: AnyObject) {
        self.view.endEditing(true)
        let name: String? = form.values()["name"] as? String
        let password: String? = form.values()["password"] as? String
        if (name == nil) || (password == nil) {
            let alertController = UIAlertController(title: "Name and password cannot be empty!", message: "Please fill the form correctly.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true){}
        } else {
            Account.MR_truncateAll()
            self.delegate.keyChain.set(name!, forKey: "userName")
            self.delegate.keyChain.set(password!, forKey: "password")
            self.delegate.defaults.setValue("yes", forKey: "LoggedIn")
            self.delegate.createCredentials()
            checkConnection() { completed in
                PKHUD.sharedHUD.contentView = PKHUDProgressView()
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 7.0) { success in
                    if completed {
                        HUD.flash(.Success, delay: 2.0) { comp in
                            if comp {
                               self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkConnection(completion: (completed: Bool) -> Void){
        print(defaults.stringForKey("userName"))
        print(defaults.stringForKey("password"))
        let url = defaults.stringForKey("url")!
        let base64: String = delegate.keyChain.get("base64")!
        Alamofire.request(.GET, "\(url)/contacts.json", headers: ["Authorization": base64], encoding:.JSON)
            .responseJSON { response in switch response.result{
            case .Success( _): response
                completion(completed: true)
            case .Failure(let Error):
                let alertController = UIAlertController(title: "Could not connect to server!", message: "Please check your URL and credentials.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true){}
                print("Request faild with error \(Error)")
                }
        }
    }
    
    private func addForms(toForm form: Form) {
        nameRow = TextRow() {
            $0.placeholder = "Name"
            $0.tag = "name"
            $0.cellSetup({ (cell, row) in
                cell.becomeFirstResponder()
            })
        }
        form +++ Section("")
        form +++ Section("Login Name")
            <<< nameRow
        form +++ Section("Password")
            <<< PasswordRow() {
                $0.placeholder = "Password"
                $0.tag = "password"
                $0.cellSetup({ (cell, row) in
                    cell.becomeFirstResponder()
                })
        }
        
    }
    
}
