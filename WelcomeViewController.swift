//
//  WelcomeViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 01/11/2018.
//  Copyright © 2018 CS_UCC. All rights reserved.
//

import UIKit
import FirebaseFirestore

class WelcomeViewController: UIViewController, UITextFieldDelegate {
 // reference to labels and textfields on the view
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var notFoundLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       self.passwordTF.delegate = self as? UITextFieldDelegate
       self.emailTF.delegate = self as? UITextFieldDelegate
        
        errorLabel.isHidden = true
        notFoundLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    // triggerd firebase code to login user and initialises persistent storage
    // segues to loginwaiting view where code executes in the appdelegate to perform login
    @IBAction func loginPressed(_ sender: Any) {
        if emailTF.text != "" && passwordTF.text != ""{
            let userDefaults = UserDefaults.standard
            // saves username for temporary use if login is successful the email is used to gather other info from database
            // this is done so that the email doesnt have to be passed into multiple functuons and across viewcontrollers 
            userDefaults.set(String(emailTF.text!), forKey: "tempEmail")
            userDefaults.synchronize()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.doLogin(email:emailTF.text!,password: passwordTF.text!)
            saveToUserDefault()
            self.performSegue(withIdentifier: "logintowaiting", sender: nil)
        }
        else{
            errorLabel.isHidden = false
        }
    }
    
      // function to save retrieved databse data to user persistent storage
    func saveToUserDefault(){
        // code to access database
        let userDefaults = UserDefaults.standard
        let tempEmail = userDefaults.string(forKey: "tempEmail")
        let db = Firestore.firestore()
        db.collection("userData").whereField("email", isEqualTo: tempEmail!).getDocuments { (snapshot, error) in
            // handles errors
            if error != nil{
                print(error!)
                // add label to display info on the VC
            }
                // if email not found then add entries
            else if (snapshot?.isEmpty)! {
                print("Snapshot empty")
            }
                // if email found print that it already exists
            else{
                for document in (snapshot?.documents)!{
                    if let user = document.data()["username"] as? String {
                        let weight = (document.data()["weight"] as? Int)
                        let height = (document.data()["height"] as? Int)
                        let gender = (document.data()["gender"] as? String)
                        let email = (document.data()["email"] as? String)
                        let age = (document.data()["age"] as? Int)
                        let bacResults = (document.data()["bacResults"] as! Array<Double>)
                        let unitResults = (document.data()["unit"] as! Double)
                        let costResults = (document.data()["cost"] as! Double)
                        let calResults = (document.data()["cal"] as! Double)
                        print("saving")
                        userDefaults.set(user, forKey: "user")
                        userDefaults.set(email, forKey: String(user + "email"))
                        userDefaults.set(weight, forKey: String(user + "weight"))
                        userDefaults.set(height, forKey:String(user + "height"))
                        userDefaults.set(gender, forKey: user + "gender")
                        userDefaults.set(age, forKey: user + "age")
                        userDefaults.set(bacResults, forKey: "BACArray")
                        userDefaults.set(costResults, forKey: "cost")
                        userDefaults.set(unitResults, forKey: "unit")
                        userDefaults.set(calResults, forKey: "cal")
                        
                        userDefaults.synchronize()
                        print("data saved")
                        print(user)
                        
                        
                    }
                }
            }
        }
    }
    
     // allows the user to press return button to hide keyboard on the user interface
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        passwordTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        return true
    }

}
