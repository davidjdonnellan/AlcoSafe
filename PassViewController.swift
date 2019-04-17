//
//  PassViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 25/03/2019.
//  Copyright © 2019 CS_UCC. All rights reserved.
//

import UIKit

class PassViewController: UIViewController {
    
    @IBOutlet weak var newPass2TF: UITextField!
    @IBOutlet weak var newPass1TF: UITextField!
    @IBOutlet weak var oldPassTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePassword(_ sender: Any) {
        errorLabel.text = "Passwords do not match..."
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
