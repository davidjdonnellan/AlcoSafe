//
//  LoggingInViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 13/01/2019.
//  Copyright © 2019 CS_UCC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class LoggingInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         // notification obsevers wait for notification from uthentication database to say login was successful or unsuccessful
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"logintriggered"),object:nil,queue:nil,using:successNotification)
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"loginfailed"),object:nil,queue:nil,using:backToLogin)
        
        }
    
     // depending on the notification returned login progresses to the users dashboard
    func successNotification(notification:Notification){
        performSegue(withIdentifier: "logindone", sender: self)
    }
    
    // if login fails/failure to authenticate occurs the user is brought back to the login screen
    func backToLogin(notification:Notification){
        performSegue(withIdentifier: "backToLogin", sender: self)
   
    }

}




        

