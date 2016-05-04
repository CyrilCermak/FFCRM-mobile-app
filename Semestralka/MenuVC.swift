//
//  menuVC.swift
//  Semestralka
//
//  Created by Cyril on 13/03/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit

class MenuVC : ENSideMenuNavigationController {
    
    override func viewDidLoad() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tvc = storyboard.instantiateViewControllerWithIdentifier("MenuTableVC") as! MenuTableVC
            sideMenu = ENSideMenu(sourceView: self.view, menuViewController: tvc, menuPosition:.Left)
            sideMenu?.menuWidth = 200
            // show the navigation bar over the side menu view
            view.bringSubviewToFront(navigationBar)
        
    }
    
    
    
  }
