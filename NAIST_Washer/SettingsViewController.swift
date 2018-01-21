//
//  SettingsViewController.swift
//  NAIST_Washer
//
//  Created by Edess Akpa on 12/11/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit
import Parse
import MessageUI
import GoogleMobileAds

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //outlets
    @IBOutlet weak var lbl_userRegisterAtBldg: UILabel!
    @IBOutlet weak var lbl_userRegisterAtFl: UILabel!
    @IBOutlet weak var btnSendComments: UIButton!
    
    @IBOutlet weak var SgControl_Building: UISegmentedControl!
    @IBOutlet weak var SgControl_Floor: UISegmentedControl!
    
    var bannerView_Settings: GADBannerView!

    
    
    // define variables
    var buildingNumb = "0"
    var floorNumb = "0"
    
    // localized Strings (to support devices set with Japanese language )
    let confirmation_String = NSLocalizedString("allTab.Confirmation", comment: "")
    let infoReq_String = NSLocalizedString("settingsTab.detailsRequired", comment: "info required")
    let buildFloor_String = NSLocalizedString("settingsTab.numbBuild", comment: "need building & floor number")
    let registAtBldg_String = NSLocalizedString("settingsTab.buildRegister", comment: "register at building")
    let registAtBldgNum_String = NSLocalizedString("settingsTab.bldgRegisNum", comment: "register at building number")
    let registAtFloor_String = NSLocalizedString("settingsTab.floorRegister", comment: "...th Floor")
    let stopNotif_String = NSLocalizedString("settingsTab.notifStopNotif", comment: "stop getting notif")
    let deviceMailSettings_String = NSLocalizedString("settingsTab.EmailNotSend", comment: "check e-mail config")
    let emailSendError_String = NSLocalizedString("settingsTab.EmailError", comment: "error when sending mail")
    let emailSendWell_String = NSLocalizedString("settingsTab.EmailSent", comment: "email sent well")
    let emailBody_String = NSLocalizedString("settingsTab.EmailBody", comment: "1st line of email ")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //check if user had previously selected his building and floor number
        if let userBuilding = UserDefaults.standard.value(forKey: "build_Numb"){
            
            lbl_userRegisterAtBldg.text = "Building \(userBuilding),"
            print("**** selected building: \(userBuilding)")
            SgControl_Building.selectedSegmentIndex = Int("\(userBuilding)")!
        }
        
        if let userFloor = UserDefaults.standard.value(forKey: "floor_Numb"){
            lbl_userRegisterAtFl.text = "Floor \(userFloor)"
            print("selected floor: \(userFloor)")
            SgControl_Floor.selectedSegmentIndex = Int("\(userFloor)")!
        }
        
        
        //manage banner view
        bannerView_Settings = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView_Settings)
        
        //Configure GADBannerView properties
        bannerView_Settings.adUnitID = "ca-app-pub-3940256099942544/2934735716" // ****** testing adUnit id MUST be changed after testing and debbugging ******
        bannerView_Settings.rootViewController = self
        
        //Load an ad: Once the GADBannerView is in place and its properties configured, it's time to load an ad
        bannerView_Settings.load(GADRequest())

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    // manage building number segmentedController
    @IBAction func SgController_BuildingNumb(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            buildingNumb = "0";
            print("buildingNumb = \(buildingNumb)")
        case 1:
            buildingNumb = "1";
            print("buildingNumb = \(buildingNumb)")
        case 2:
            buildingNumb = "2";
            print("buildingNumb = \(buildingNumb)")
        case 3:
            buildingNumb = "3";
            print("buildingNumb = \(buildingNumb)")
        case 4:
            buildingNumb = "4";
            print("buildingNumb = \(buildingNumb)")
        case 5:
            buildingNumb = "5";
            print("buildingNumb = \(buildingNumb)")
        case 6:
            buildingNumb = "6";
            print("buildingNumb = \(buildingNumb)")
        case 7:
            buildingNumb = "7";
            print("buildingNumb = \(buildingNumb)")
            
        default:
            break;
        }
        lbl_userRegisterAtBldg.text = "\(buildingNumb) \(registAtBldgNum_String),"
    }
    
    
    // manage floor number segmentedController
    @IBAction func SgController_FloorNumb(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            floorNumb = "0";
            print("floorNumb = \(floorNumb)")
        case 1:
            floorNumb = "1";
            print("floorNumb = \(floorNumb)")
        case 2:
            floorNumb = "2";
            print("floorNumb = \(floorNumb)")
        case 3:
            floorNumb = "3";
            print("floorNumb = \(floorNumb)")
        case 4:
            floorNumb = "4";
            print("floorNumb = \(floorNumb)")
        case 5:
            floorNumb = "5";
            print("floorNumb = \(floorNumb)")
        default:
            break;
        }
        lbl_userRegisterAtFl.text = "\(floorNumb) \(registAtFloor_String)."
    }
    
    
    
    
    // register to building#Floor#
    @IBAction func btnStartReceiveNotif(_ sender: UIButton) {
        print("btnStartReceiveNotif pushed")
        
        if(buildingNumb == "0" || floorNumb == "0"){
            print("Please select a proper building number")
            
            displayMyAlertMessages(infoReq_String, alertMessage: buildFloor_String)
        }else
        {
            
            // display confirmation Alert
            displayMyAlertMessages(confirmation_String, alertMessage: "\(registAtBldg_String) \(buildingNumb) \(registAtBldgNum_String), \(floorNumb) \(registAtFloor_String)")
            
        }
        
        
    }
    
    
    // stop receiving notification from channel building#Floor#
    @IBAction func btnStopReceiveNotif(_ sender: UIButton) {
        
        displayMyAlertMessages(confirmation_String, alertMessage: stopNotif_String)
        
        // unregister user from channelName
    }
    
    // button to contact developper
    @IBAction func btnSendComment(_ sender: UIButton) {
        
        //check if the device can send mail.
        //if not, disable "send comments" button
        if MFMailComposeViewController.canSendMail(){
            
            sendEmail()
            
        }else{
            print("Mail services are not available")
            //btnSendComments.isEnabled = false
            displayMyAlertMessages("Ooops !!!", alertMessage: deviceMailSettings_String)
            
        }
        
        
        
        
    }
    
    //function to send the email
    func sendEmail(){
        let composeViewContr = MFMailComposeViewController()
        composeViewContr.mailComposeDelegate = self
        
        //configure the fiels of the interface
        composeViewContr.setToRecipients(["akpa.elder.zx6@is.naist.jp"])
        composeViewContr.setSubject("[WasherManager] Message from the app")
        composeViewContr.setCcRecipients(["akpaelder@gmail.com"])
        composeViewContr.setMessageBody(emailBody_String, isHTML: false)
        
        //present the view controller
        self.present(composeViewContr, animated: true, completion: nil)
    }
    
    //the mail compose view controller calls the mailComposeController(_:didFinishWith:error:)
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if (error != nil){
            //print("email has been sent")
        }
        else{
            displayMyAlertMessages("Oops !", alertMessage: emailSendError_String)
            //print("There was an error, but your email has been delivered. \n This error: \(String(describing: error?.localizedDescription))")
        }
        
        
        controller.dismiss(animated: true, completion: nil)
        displayMyAlertMessages("Sent !", alertMessage: emailSendWell_String)

    }
    
    
    
    
    // function to display alert messages
    func displayMyAlertMessages(_ alertTitle:String, alertMessage:String){
        print("[==> Elder: Debugg alert Messages ==> ]")
        
        let myAlertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        //// OK action button
        let alertAction_OK = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            //print("alert message: OK pushed")
            
            if(alertTitle == self.confirmation_String){
                
                // if user confirms his selection, create the group channel name by combining bulding numb and floor num
                let channelName = "building\(self.buildingNumb)Floor\(self.floorNumb)"
                print("channelName === \(channelName)")
                
                // subscription/register to channelName
                let currentInstallation = PFInstallation.current()
                currentInstallation?.addUniqueObject(channelName, forKey: "channels")
                currentInstallation?.saveInBackground(block: { (success, error) in
                    if(success){
                        print("subscribed to \(channelName) ok")
                        
                        // save data in the default memory of the app
                        UserDefaults.standard.set(self.buildingNumb, forKey: "build_Numb")
                        UserDefaults.standard.set(self.floorNumb, forKey: "floor_Numb")
                        UserDefaults.standard.synchronize()
                        
                        print("Bulding and floor number have been SAVED to UserDefault")
                        
                    }else{
                        print("DID NOT subscribe to \(channelName) ")
                        
                    }
                })
                
                
            }
        }
        myAlertView.addAction(alertAction_OK)
        
        // CANCEL action button
        let alertAction_Cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction!) in
            print("alert message: CANCEL pushed")
        }
        
        
        
        if(alertTitle == self.confirmation_String){
            myAlertView.addAction(alertAction_Cancel)
            
        }
        
        present(myAlertView, animated: true, completion: nil)
        
    }

}
