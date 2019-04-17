//
//  SigningUpViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 13/02/2019.
//  Copyright © 2019 CS_UCC. All rights reserved.
//

import UIKit

class SigningUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // observer to wait for notification of successful signup
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"signupCompleting"),object:nil,queue:nil,using:successNotification)
    }
    
    func successNotification(notification:Notification){
        performSegue(withIdentifier: "signupDone", sender: nil)
        
    }
}
