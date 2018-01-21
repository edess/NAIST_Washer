//
//  ViewController.swift
//  NAIST_Washer
//
//  Created by Edess Akpa on 12/10/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class ViewController: UIViewController {
    
    
    
    // define variable
    var buildingNumb = "0"
    var floorNumb = "0"
    var bannerView: GADBannerView!
    
    // localized Strings (to support devices set with Japanese language )
    let info_String = NSLocalizedString("allTab.Information", comment: "")
    let goSettings_String = NSLocalizedString("homeTab.GoToSettings", comment: "go to settings tab")
    let freeWashingMach_String = NSLocalizedString("homeTab.PickUpWashing", comment: "free the washing machine")
    let freeDryerMach_String = NSLocalizedString("homeTab.PickUpDryer", comment: "free the dryer machine")
    let notifSent_String = NSLocalizedString("homeTab.NotifSend", comment: "notif sent success")
    let notifNotSent_String = NSLocalizedString("homeTab.NotifNotSend", comment: "notif NOT sent")



    override func viewDidLoad() {
        super.viewDidLoad()
    
        //check if user had previously selected his building and floor number
        if let userBuilding = UserDefaults.standard.value(forKey: "build_Numb"){
            buildingNumb = "\(userBuilding)"
        }
        
        if let userFloor = UserDefaults.standard.value(forKey: "floor_Numb"){
            floorNumb = "\(userFloor)"
        }
        
        
        /*
         manage AdMobs (advertissement within the app)
         */
       
        // we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
    
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        
        //Configure GADBannerView properties
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // ****** testing adUnit id MUST be changed after testing and debbugging ******
        bannerView.rootViewController = self
        
        //Load an ad: Once the GADBannerView is in place and its properties configured, it's time to load an ad
        bannerView.load(GADRequest())
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //manage the btn "Need to use the washing machine"
    @IBAction func btnFreeTheWashers(_ sender: UIButton) {
        //print("btnFreeTheWashers pushed")
        
        //if user building and floor number = 0, => ask him to select his building and floor in the SETTINGS tab
        if(buildingNumb == "0" || floorNumb == "0"){
            displayMyAlertMessages(info_String, alertMessage: goSettings_String)
        }else{
            // send notif to other washing_machines users on the same floor
            sendNotifToOther(theAlertMessage: freeWashingMach_String)
        }
        
    }
    
    
    
    //manage button free the dryer
    @IBAction func btnFreeTheDryer(_ sender: UIButton) {
        
        //if user building and floor number = 0, => ask him to set his building and floor in the SETTINGS tab
        if(buildingNumb == "0" || floorNumb == "0"){
            displayMyAlertMessages(info_String, alertMessage: goSettings_String)
        }else{
            // send notif to other washing_machines users on the same floor
            
            sendNotifToOther(theAlertMessage: freeDryerMach_String)
        }
        
    }
    
    
    func sendNotifToOther(theAlertMessage: String){
        // send notif to other washing_machines users on the same floor
        
        let data = [
            "badge" : "Increment",
            "alert" : "Message from Building \(buildingNumb), Floor \(floorNumb).\n\(theAlertMessage) ",
        ]
        let request = [
            "channels" : "building\(buildingNumb)Floor\(floorNumb)", /// get the channel name from the app memory
            "data" : data
            ] as [String : Any]
        
        PFCloud.callFunction(inBackground: "iosPush", withParameters: request as [NSObject : AnyObject]) { (successful, error) in
            if((successful) != nil){
                print("push notification sent")
                
                // display alert view to inform the user that floormate as been informed
                self.displayMyAlertMessages("Message sent", alertMessage: self.notifSent_String)
                
            }else{
                print("push notification NOT sent")
                //print(error as Any)
                
                // display alert view to inform the user that we encountered a problem when notifying floormate
                self.displayMyAlertMessages("Error", alertMessage: self.notifNotSent_String)
                
                
            }
        }
        
    }
    
    
    
    // function to add banner for add
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
           view.addSubview(bannerView)
           view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self.bottomLayoutGuide,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
        
    }

    
    
    // function to display alert messages
    func displayMyAlertMessages(_ alertTitle:String, alertMessage:String){
        print("[==> Elder: Debugg alert Messages ==> ]")
        
        let myAlertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        //// OK action button
        let alertAction_OK = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            print("alert message: OK pushed")
        }
        
        myAlertView.addAction(alertAction_OK)
        present(myAlertView, animated: true, completion: nil)
        
    }

}

