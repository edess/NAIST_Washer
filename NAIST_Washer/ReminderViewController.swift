//
//  ReminderViewController.swift
//  NAIST_Washer
//
//  Created by Edess Akpa on 12/13/17.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMobileAds

class ReminderViewController: UIViewController {
    
    
    @IBOutlet weak var myTimePicker: UIDatePicker!
    @IBOutlet weak var lblAlarmTime: UILabel!
    
    var bannerView_Reminder: GADBannerView!
    
    // localized Strings (to support devices set with Japanese language )
     let notifTitle_String = NSLocalizedString("reminderTab.NotifTitle", comment: "title of notif")
    let notifBody_String = NSLocalizedString("reminderTab.NotifBody", comment: "body of notif")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //manage banner view
        bannerView_Reminder = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView_Reminder)
        
        //Configure GADBannerView properties
        bannerView_Reminder.adUnitID = "ca-app-pub-3940256099942544/2934735716" // ****** testing adUnit id MUST be changed after testing and debbugging ******
        bannerView_Reminder.rootViewController = self
        
        //Load an ad: Once the GADBannerView is in place and its properties configured, it's time to load an ad
        bannerView_Reminder.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func alarmDPick(_ sender: UIDatePicker) {
        
        let userDate = sender.date
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.day, .hour, .minute], from: userDate)
        
        
        
        lblAlarmTime.text = "\(dateComponent.hour ?? 00)h : \(dateComponent.minute ?? 00)mm"
        print("picke time = \(lblAlarmTime.text ?? "not yet define")")
        
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
    
    
    
    @IBAction func btnSetAlarm(_ sender: UIButton) {
        
        // step1: create the notification content
        let notifContent = UNMutableNotificationContent()
        notifContent.title = notifTitle_String
        notifContent.body = notifBody_String
        notifContent.sound = UNNotificationSound.default()
        
        
        // step2: Trigger at a specific date and time. The trigger is created using a date components object
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: myTimePicker.date)
        let mytrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        
        // step3: schedulling With both the content and trigger ready we create a new notification request and add it to the notification center.
        let notif_identifier = "LocalNotifIdentifier"
        let myrequest = UNNotificationRequest(identifier: notif_identifier, content: notifContent, trigger:mytrigger)
        
        
        
        //step 4: access the notification "center" already defined in the AppDelegate
        // and pass to it the new  notif request
        
        
        UNUserNotificationCenter.current().add(myrequest) { (error) in
            if((error) != nil){
                // work well
                print(" New request sent to the Notification center")

            }else{
                //somethin went worng
                print("Couldn't add the new request to the Notification center")
            }
        }
        
    }
    

   

}
