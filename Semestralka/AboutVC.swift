//
//  AboutVC.swift
//  Semestralka
//
//  Created by Cyril on 26/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBAction func buttonMenuClicked(sender: AnyObject) {
        toggleSideMenuView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
