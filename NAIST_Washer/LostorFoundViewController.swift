//
//  LostorFoundViewController.swift
//  NAIST_Washer
//
//  Created by Edess Akpa on 2017/12/19.
//  Copyright © 2017 The Elder Company. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LostorFoundViewController: UIViewController {
    
    @IBOutlet weak var ubiChanGifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // manage ubichan gif
        ubiChanGifView.loadGif(name: "ubiChan")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}
