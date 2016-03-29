//
//  NewAccountVC.swift
//  Semestralka
//
//  Created by Cyril on 21/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

class NewAccountOldVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    @IBOutlet var textLabelName: UITextField!
    
    var assignTo = ["Jedna", "Dva", "Tri"]
    var category = ["1", "2", "3"]
    var stars = ["*","**","***"]
    var pickerAssignTo = UIPickerView()
    var pickerCategory = UIPickerView()
    var pickerStars = UIPickerView()
    @IBOutlet var textFieldCategory: UITextField!
    @IBOutlet var textFieldAssignTo: UITextField!
    @IBOutlet var textFieldStars: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabelName.becomeFirstResponder()
        pickerAssignTo.delegate = self
        pickerCategory.delegate = self
        pickerStars.delegate = self
        pickerAssignTo.dataSource = self
        pickerCategory.dataSource = self
        pickerStars.dataSource = self
        textFieldAssignTo.inputView = pickerAssignTo
        textFieldCategory.inputView = pickerCategory
        textFieldStars.inputView = pickerStars
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonCreateClicked(sender: AnyObject) {
        print("button create clicked!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerAssignTo {
            textFieldAssignTo.text =  assignTo[row]
        } else if pickerView == pickerCategory {
            textFieldCategory.text = category[row]
        }else if pickerView == pickerStars {
            textFieldStars.text = stars[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerAssignTo {
            return assignTo.count
        } else if pickerView == pickerCategory {
            return category.count
        } else if pickerView == pickerStars {
            return stars.count
        }
        return assignTo.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerAssignTo {
            return assignTo[row]
        } else if pickerView == pickerCategory {
            return category[row]
        } else if pickerView == pickerStars {
            return stars[row]
        }
        return nil
    }
    
}
