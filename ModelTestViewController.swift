//
//  ModelTestViewController.swift
//  Charts
//
//  Created by David Donnellan on 24/01/2019.
//

import UIKit
import CoreData
import CoreML
import  FirebaseFirestore


class ModelTestViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var drinksTable: UITableView!
    @IBOutlet weak var BACLabel: UILabel!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var viewTime: UIButton!
    @IBOutlet weak var CalcButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    let fixedTabNum = 3 // refers to specific view controller should not be changed
    
    
    //DRINKS THAT CAN BE SELECTED
    var lagerPt = "Lager Pint (568ml)"
    var stoutPt = "Stout Pint (568ml)"
    var lagerGls = "Lager Glass (284ml)"
    var stoutGls = "Stout Glass (284ml)"
    var  whtWineGls = "White Wine Glass (150ml)"
    var  redWineGls = "Red Wine Glass (150ml)"
    var  ciderPt = "Cider Pint (568ml)"
    var  ciderGls = "Cider Glass (284ml)"
    var  lgtLgrPt = "Light Lager Pint (568ml)"
    var  lgtLgrGls = "Light Lager Glass (284ml)"
    var  gin = "Gin (35.5ml)"
    var  vodka = "Vodka (35.5ml)"
    var  whiskey = "Whiskey (35.5ml)"
    var  proseccoGls = "Prosecco Glass (150ml)"
    var  brandy = "Brandy (35.5ml)"
    
    // data strutues that hold drink info
    var drinksArray:Array<String> = []
    var drinkUnits = [String:Double]()
    var drinkCosts = [String:Double]()
    var drinkCalories = [String:Double]()
    var totalUnits = [String:(Int,Double)]()
    var tempUnits:Double = 0.0
    var BAC:Double = 0.0
    var genderValue:Double = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        CalcButton.layer.cornerRadius = 10
        CalcButton.clipsToBounds = true
        timerButton.layer.cornerRadius = 10
        timerButton.clipsToBounds = true
        viewTime.isHidden = true
        drinksTable.dataSource = self
        drinksTable.delegate = self
        
        // initialising the data for each drink
        // this data structures are queried when the user initiates a calculation
        drinksArray = [lagerPt,stoutPt,lagerGls,stoutGls,whtWineGls,redWineGls,ciderPt,ciderGls,lgtLgrPt,lgtLgrGls,gin,vodka,whiskey,proseccoGls,brandy]
        
        drinkUnits = [lagerPt:2,stoutPt:2,lagerGls:1,stoutGls:1,whtWineGls:1.5,redWineGls:1.5,ciderPt:2,ciderGls:1,lgtLgrPt:2,lgtLgrGls:1,gin:1.3,vodka:1.3,whiskey:1.4,proseccoGls:1.5,brandy:1]
        
         drinkCosts = [lagerPt:5.9,stoutPt:5.5,lagerGls:3.5,stoutGls:3.5,whtWineGls:7,redWineGls:7,ciderPt:6,ciderGls:3,lgtLgrPt:5.9,lgtLgrGls:3.5,gin:7,vodka:6,whiskey:6,proseccoGls:8,brandy:5]
        
        drinkCalories = [lagerPt:176,stoutPt:210,lagerGls:90,stoutGls:105,whtWineGls:120,redWineGls:127,ciderPt:250,ciderGls:125,lgtLgrPt:138,lgtLgrGls:69,gin:60,vodka:70,whiskey:85,proseccoGls:80,brandy:100]
      
    }
    // Code beyond this point is Model Prediction Code
    //MACHINE LEARNING MODEL
    let model = BACResults()
    
    @IBAction func calcPressed(_ sender: Any) {
     if timeTF.text != ""{
        //PERSISTENT STORAGE - user data retrieved from persistent storage for use within model to predict BAC
        let defaults = UserDefaults.standard
        let user = defaults.string(forKey:"user")! as String
        let email = defaults.string(forKey:user + "email")! as String
        let weight = Double(defaults.integer(forKey: user + "weight"))
        let height = Double(defaults.integer(forKey: user + "height"))
        let age = (defaults.string(forKey:user + "age")! as NSString).doubleValue
        let gender = defaults.string(forKey:user + "gender")
        let nationality = "irish"
        var yearlyCost = Double(defaults.integer(forKey:"cost"))
        var yearlyCalories = Double(defaults.integer(forKey:"cal"))
        var yearlyUnits = Double(defaults.integer(forKey:"unit"))
        defaults.synchronize()
        tempUnits = 0.0
        let time = (timeTF.text! as NSString).doubleValue
        var units:Double = 0.0
       
   
       // iterates dictionary to find units entered by the users and calculates cost calories and units consumed
        var cost = 0.0
        var cals = 0.0
        var unt = 0.0
        for x in totalUnits{
            print(x.key)
            // here adds relevant info to the Units cost and calories array
            let tmpCost =  Double(drinkCosts[x.key]! * Double(x.value.0))
            cost += tmpCost
            yearlyCost += tmpCost
            
            let tmpCals = Double(drinkCalories[x.key]! * Double(x.value.0))
            cals += tmpCals
            yearlyCalories += tmpCals
            
            let tmpUnit = Double(drinkUnits[x.key]! * Double(x.value.0))
            unt += tmpUnit
            yearlyUnits += tmpUnit
            //add to userdefaults
            
            
            print(Double(x.value.0) * x.value.1)
            tempUnits += (Double(x.value.0) * x.value.1)
            print(tempUnits)
        }
        units = Double(tempUnits)
       //makes sure units is greater than 0 and changes the gender to a the gender constant for use within the model
        if units <= 0.0 {
            BACLabel.text = String(0)
            return
        }
        if gender == "male"{
            genderValue = 0.68
        }
        else{
            genderValue = 0.55
        }
        
        if true{
        //using model to predict results instead of using widmark formula
            guard let scene = try? model.prediction(age: age, gender: genderValue, hrsDrinking: time, unitsConsumed: units, weight: weight)
        
        else {
            fatalError("Unexpected Error")
            }
        units = 0.0
            
            BAC = scene.BAC
            
             // following code sets user statistics and colours for use within the app when a BAC reading is calculated
            if scene.BAC <= 0.1{
                BACLabel.text = "BAC: " + String(format: "%.4f", scene.BAC)
                BACLabel.textColor = UIColor(red: 54/255, green: 208/255, blue: 63/255, alpha: 1.0)
                infoLabel.text = "Units: \(unt)"
                calLabel.text = "Calories: \(cals)"
                costLabel.text = "Cost: \("€" + String(format: "%.2f",cost))"
            }
            else if scene.BAC > 0.1 && scene.BAC <= 0.2{
                BACLabel.text = "BAC: " + String(format: "%.4f", scene.BAC)
                 BACLabel.textColor = UIColor.yellow
                infoLabel.text = "Units: \(unt)"
                calLabel.text = "Calories: \(cals)"
                costLabel.text = "Cost: \("€" + String(format: "%.2f",cost))"
            }
            else if scene.BAC > 0.2 && scene.BAC <= 0.3{
                BACLabel.text = "BAC: " + String(format: "%.4f", scene.BAC)
                 BACLabel.textColor = UIColor.orange
                infoLabel.text = "Units: \(unt)"
                calLabel.text = "Calories: \(cals)"
                costLabel.text = "Cost: \("€" + String(format: "%.2f",cost))"
            }
            else{
                 BACLabel.text = "BAC: " + String(format: "%.4f", scene.BAC)
                 BACLabel.textColor = UIColor(red: 243.0/255, green: 75/255, blue: 53/255, alpha: 1.0)
                infoLabel.text = "Units: \(unt)"
                calLabel.text = "Calories: \(cals)"
                costLabel.text = "Cost: \("€" + String(format: "%.2f",cost))"
            }
            // retrieving user object array of BAC results
            // this array will be used in charts
            
            let userDefaults = UserDefaults.standard
            var array = userDefaults.object(forKey: "BACArray") as! Array<Double>
            array += [scene.BAC]
            userDefaults.set(array, forKey: "BACArray")
            userDefaults.set(yearlyCost, forKey: "cost")
            userDefaults.set(yearlyUnits, forKey: "unit")
            userDefaults.set(yearlyCalories, forKey: "cal")
            userDefaults.synchronize()
            // adds bac array to database updates BAC array in database
            let db = Firestore.firestore()
            //print(email)
            db.collection("userData").whereField("email", isEqualTo: email).getDocuments{ (snapshot, error) in
                // handles errors
                if error != nil{
                    print(error!)
                }
                    // if email not found then add entries
                else {
                    print("No data returned")
                    let dict:[String:Any] = [
                        "bacResults": array,
                        "unit":yearlyUnits,
                        "cal":yearlyCalories,
                        "cost":yearlyCost
                    ]
                    db.collection("userData").document(email).updateData(dict)
                }
            }

        }
            
        viewTime.isHidden = false
        }
        else{
            print("Not data is entered")
            BACLabel.text = String(0)
        }
 
    }
    
    
   // this code passes all necessary data to timer view to start if the timer start button has been pressed
   @IBAction func viewTimePressed(_ sender: Any) {
    let time = (timeTF.text! as NSString).doubleValue
    let tmpUnit = tempUnits - time
    print(tmpUnit)
    //time in seconds until able to drive
    let temptimeSeconds = tmpUnit * 60 * 60
    print(temptimeSeconds)
   // doesnt work
    let secondTab = self.tabBarController?.viewControllers![fixedTabNum] as! TimerViewController
    secondTab.buttonClicked = true
    secondTab.recvTime = String(temptimeSeconds)
    secondTab.recvBAC = BAC
    tempUnits = 0.0
    _ = self.tabBarController?.selectedIndex = 3
  
    }
    // hides keyboard when user touches outside of text box
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //hides keyboard when user presses return button
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        timeTF.resignFirstResponder()
        return true
    }
    
    
}

// this extenstion is used to displayed the table of drinks again with reusable cells
extension ModelTestViewController: UITableViewDataSource, UITableViewDelegate {
    // reason for having to define the array twice is that an extension doesnt allow the retrieval of a persistant object
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drinksTable.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as? DrinkTableViewCell
        cell!.cellDelegate = self
        cell!.index = indexPath
        cell!.textLabel!.text = String(drinksArray[indexPath.row])
        return cell!
    }


}
// this extension adds data to array when a stepper within a specific cell is pressed keeping track of drink count
extension ModelTestViewController:TableViewNew{
    func click(index: Int,stepperV:Int) {
        totalUnits[drinksArray[index]] = (stepperV,drinkUnits[drinksArray[index]]!)
            print(totalUnits)
    }
    
    
}


