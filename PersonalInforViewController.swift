//
//  PersonalInforViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 12/03/2019.
//  Copyright © 2019 CS_UCC. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PersonalInforViewController: UIViewController {

    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var saved: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // allows the user to change their personal data in settings and updates it in the database and persistent storage
    //error check also added below
    @IBAction func saveNewData(_ sender: Any) {
        if weight.text != "" && height.text != "" && age.text != "" {
        let uDefault = UserDefaults.standard
        let email = uDefault.string(forKey: "tempEmail")
        uDefault.synchronize()
        let db = Firestore.firestore()
        db.collection("userData").whereField("email", isEqualTo: email!).getDocuments{ (snapshot, error) in
            // handles errors
            if error != nil{
                print(error!)
                
                // add label to display info on the VC
            }
                // if email not found then add entries
            else {
                let dict:[String:Any] = [
                    "age" : Int(self.age.text!)!,
                    "height" : Int(self.height.text!)!,
                    "weight" : Int(self.weight.text!)!
                ]
                db.collection("userData").document(email!).updateData(dict)
            }
        }
        }
        else{

            saved.text = "Please Complete all fields"
        }
        saved.text = "Save Successful"
    }

}
