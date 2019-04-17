//
//  ContentViewController.swift
//  
//
//  Created by David Donnellan on 09/11/2018.
//

import UIKit
import CoreData
import FirebaseFirestore

class ContentViewController: UIViewController, UITextFieldDelegate {
  // text fields and labels initialised
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var missingTextLabel: UILabel!
    @IBOutlet weak var genderSeg: UISegmentedControl!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var validEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTF.delegate = self as? UITextFieldDelegate
        self.emailTF.delegate = self as? UITextFieldDelegate
        self.ageTF.delegate = self as? UITextFieldDelegate
        self.weightTF.delegate = self as? UITextFieldDelegate
        self.heightTF.delegate = self as? UITextFieldDelegate
        self.userTF.delegate = self as? UITextFieldDelegate
        
        missingTextLabel.isHidden = true
        validEmail.isHidden = true
    }
    
     // allows user to touch outside textbox to hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // this button action triggers account with firebase boilerplate code to create account
    // adds the initil user variables to the databse and saves them to persistent storage by calling save to userDefaults
    @IBAction func buttonPressed(_ sender: Any) {
        // add code here that will append object to core data model.
        if emailTF.text != "" && passwordTF.text != "" && userTF.text != "" && weightTF.text != "" && heightTF.text != "" && ageTF.text != ""{
        var gender = ""
        if (genderSeg.selectedSegmentIndex == 0){
            gender = "male"
        }
        else{
            gender = "female"
        }
        // fetches db data if exists
            let db = Firestore.firestore()
            db.collection("userData").whereField("email", isEqualTo: emailTF.text!).getDocuments{ (snapshot, error) in
                // handles errors
                if error != nil{
                    print(error!)
                }
                // if email not found then add entries
                else if (snapshot?.isEmpty)!{
                    print("No data returned")
                    let dict:[String:Any] = [
                        "email" : self.emailTF.text!,
                        "username" : self.userTF.text!,
                        "age" : Int(self.ageTF.text!)!,
                        "height" : Int(self.heightTF.text!)!,
                        "weight" : Int(self.weightTF.text!)!,
                        "gender" : gender,
                        "bacResults": [],
                        "cost":0.0,
                        "unit":0.0,
                        "cal":0.0
                    ]
                    db.collection("userData").document(self.emailTF.text!).setData(dict)
                    self.saveToUserDefault(gender: gender)
    
                }
                // if email found print that it already exists
                else{
                    for document in (snapshot?.documents)!{
                        if let name = document.data()["username"] as? String {
                            print(name)
                            print("Email already exists please enter valid email")
                            self.validEmail.isHidden = false
                        }
                    }
                }
            }
        }
        
        else{
            missingTextLabel.isHidden = false
        }
        
        
     //**************  ALL DEDUNDANT CODE FROM IMPLEMENTATING COREDATA ************************
        /*let defaults = UserDefaults.standard
        let arrayOfObjectsKey = "arrayOfObjectsKey"
        let userObject = [userPersistantData(user: "David", bac: 20.0)]
        let ObjectsData = NSKeyedArchiver.archivedData(withRootObject: userObject)
        defaults.set(ObjectsData, forKey: arrayOfObjectsKey)
        print("Object Here: ",ObjectsData)
        do{
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let saveFile = documentDirectory.appendingPathComponent("library.bin")
        
        let user = userPersistantData.init(user: userTF.text!, bac: 20.0)
        let codedData = try! NSKeyedArchiver.archivedData(withRootObject: user)
        try! codedData.write(to: saveFile)
        print(codedData)
        }
        catch{
            print(error)
        }
        //UserDefaults.standard.set(data, forKey: "data")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.fetchManipulate(in: "UserData")
        let context = appDelegate.persistentContainer.viewContext
        let result = appDelegate.createRecordForEntity("UserData", inManagedObjectContext: context)
        result?.setValue(userTF.text, forKey: "user")
        result?.setValue(24.0, forKey: "bmi")
        result?.setValue(0.02, forKey: "bac")
        //let fetch = appDelegate.fetchRecordsForEntity("UserData", inManagedObjectContext: context)
        do {
            try context.save()
            print("Data Saved")
            /*let fetch = appDelegate.fetchRecordsForEntity("UserData", inManagedObjectContext: context)*/
            //   var fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        }
        catch {
            print("Failed saving")
        }
        */
        
    }
    
    // function to save data locally so db need only be accessed at login and account creation and any time where needed
    func saveToUserDefault(gender:String){
        // user default code
        let userDefaults = UserDefaults.standard
        userDefaults.set(emailTF.text, forKey: String(userTF.text! + "email"))
        userDefaults.synchronize()
        userDefaults.set(userTF.text, forKey: "user")
        userDefaults.set(emailTF.text, forKey: String(userTF.text! + "email"))
        userDefaults.set(weightTF.text, forKey: String(userTF.text! + "weight"))
        userDefaults.set(heightTF.text, forKey:String(userTF.text! + "height"))
        userDefaults.set(gender, forKey: userTF.text! + "gender")
        userDefaults.set(ageTF.text, forKey: userTF.text! + "age")
        userDefaults.set([], forKey: "BACArray")
        userDefaults.set(0.0, forKey: "cost")
        userDefaults.set(0.0, forKey: "unit")
        userDefaults.set(0.0, forKey: "cal")
        userDefaults.synchronize()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createAccount(email: emailTF.text!, password: passwordTF.text!)
        performSegue(withIdentifier: "signingUp", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        passwordTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        heightTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        userTF.resignFirstResponder()
        return true
    }
    
        //**************  ALL DEDUNDANT CODE FROM IMPLEMENTATION AND TESTING ************************
        // test button added by developer to allow bypassing create account / login eachtime a new feature was added to the applicaiton
        /* @IBAction func testButton(_ sender: Any) {
         //let appDelegate = UIApplication.shared.delegate as! AppDelegate
         //appDelegate.removeUserData()
         // code tests if the data has been saved to the model and has not been over-written.
         let defaults = UserDefaults.standard
         //let newkey = "David".hashValue
         // print(String(newkey))
         // defaults.set([], forKey: "BACArray")
         let user = defaults.string(forKey:"user")
         let weight = defaults.integer(forKey: user! + "weight")
         let height = defaults.integer(forKey: user! + "height")
         let age = defaults.string(forKey:user! + "age")
         let gender = defaults.string(forKey:user! + "gender")
         let cost = defaults.double(forKey:"cost")
         let unit = defaults.double(forKey:"unit")
         let cal = defaults.double(forKey:"cal")
         defaults.synchronize()
         print(defaults)
         print(user!,weight,height,age!,gender!,cost,unit,cal)
         let arrayOfObjectsKey = "arrayOfObjectsKey"
         let arrayOfObjectsUnarchivedData = defaults.data(forKey: arrayOfObjectsKey)!
         let arrayOfObjectsUnarchived = NSKeyedUnarchiver.unarchiveObject(with: arrayOfObjectsUnarchivedData) as? [userPersistantData]
         
         print("Here: ",arrayOfObjectsUnarchived![0])
         do{
         let fileManager = FileManager.default
         let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
         let saveFile = documentDirectory.appendingPathComponent("library.bin")
         
         let libraryReadData = try NSData(contentsOf: saveFile, options: .mappedIfSafe)
         let lib =  NSKeyedUnarchiver.unarchiveObject(with: libraryReadData as! Data)
         print(lib)
         }
         catch{
         print(error)
         }
         let data = UserDefaults.standard.value(forKey: "data")
         let user =  NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
         print("User: ",user!)
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         var list: NSManagedObject? = nil
         
         // Fetch List Records
         let lists = appDelegate.fetchManipulate(in: "UserData", StringinManagedObjectContext: context)
         // try to use better code here instead of taking fist object in model. An internal error may not return correct user as first object.
         if let listRecord = lists.first {
         // if listRecord.value(forKey: "user") as! String == "David"{
         list = listRecord
         print(list?.value(forKey: "user") as! String)
         list?.setValue(20, forKey: "annualUnits")
         // }
         } else if let newRecord = appDelegate.createRecordForEntity("UserData", inManagedObjectContext: context) {
         list = newRecord
         list?.setValue(userTF.text, forKey: "user")
         list?.setValue(24.0, forKey: "bmi")
         list?.setValue(0.02, forKey: "bac")
         }
         print("number of lists: \(lists.count)")
         print("--")
         
         if let list = list {
         print(list)
         } else {
         print("unable to fetch or create list")
         }
         do {
         // Save Managed Object Context
         try context.save()
         } catch {
         print("Unable to save managed object context.")
         }
         //return true
         }*/

}
