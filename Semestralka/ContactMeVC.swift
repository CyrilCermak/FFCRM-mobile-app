//
//  ViewController.swift
//  Semestralka
//
//  Created by Cyril on 08/05/16.
//  Copyright © 2016 cyril. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Social
import MessageUI

class ContactMeVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBAction func buttonMenuClicked(sender: AnyObject) {
        self.toggleSideMenuView()
    }
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        let initialLocation = CLLocation(latitude: 50.0867875, longitude: 14.4634069)
        centerMapOnLocation(initialLocation)
        addMapObject()
    }
    
    func addMapObject(){
        let mapObject = MapObject(title: "Unicorn College", locationName: "Pod Parukářkou 3", discipline: "School", coordinate: CLLocationCoordinate2D(latitude: 50.0867875, longitude: 14.4634069))
        self.mapView.addAnnotation(mapObject)
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius , regionRadius )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailClicked(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        mailComposeViewController.navigationBar.tintColor = UIColor.whiteColor()
        mailComposeViewController.navigationBar.barTintColor = UIColor.init(red:0.037, green:0.777, blue:0.118, alpha:1.00)
        mailComposeViewController.navigationBar.titleTextAttributes = [NSFontAttributeName:  UIFont(name: "Avenir-Light" , size: 24)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["cyril.cermak@gmail.com"])
        mailComposerVC.setSubject("Thank you Cyril.")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendeMailError = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        sendeMailError.addAction(ok)
        presentViewController(sendeMailError, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func fbClicked(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/cyril.cermak")!)
    }
    
    @IBAction func phoneClicked(sender: AnyObject) {
        makeCall("+420776208919")
    }
    
    func makeCall(phone: String) {
        
        let alert = UIAlertController(title: "Cyril Cermak", message: "Do you want to call \(phone)?", preferredStyle: .Alert)
        let yes = UIAlertAction(title: "Yes", style: .Default, handler: { clicked in
            let formatedNumber = phone.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
            let phoneUrl = "tel://\(formatedNumber)"
            let url:NSURL = NSURL(string: phoneUrl)!
            UIApplication.sharedApplication().openURL(url)
        
        })
        let no = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}


class MapObject: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
}


