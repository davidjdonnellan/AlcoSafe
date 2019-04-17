//
//  NewTableViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 11/03/2019.
//  Copyright © 2019 CS_UCC. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // calls function in app delegate to perform logout based on firebase authentication boilerplate code
    // also clears persistent storage to allow new user to login
    @IBAction func logout(_ sender: Any) {
        do{
            print(Auth.auth().currentUser as Any)
            try Auth.auth().signOut()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.removeUserData()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "x101") as! WelcomeViewController
            self.present(vc, animated: true, completion: nil)
        }
        catch let logoutError{
            print(logoutError)
            
        }
        print(Auth.auth().currentUser as Any)
    
    }


}
