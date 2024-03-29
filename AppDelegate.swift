//
//  AppDelegate.swift
//  AlcoholMonitor 
//
//  Created by David Donnellan on 02/10/2018.
//  Copyright © 2018 CS_UCC. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool  {
       FirebaseApp.configure()
        // removes all data in persistant storage
        //resetAllRecords(in: "UserData")
        // Override point for customization after application launch.
        return true
    }
    
    //boilerplate code that is used to access firebase authentication system to do login
    func doLogin(email:String,password:String){
        Auth.auth().signIn(withEmail:email,password:password){
            (authResult,error) in
            if let error = error{
                if AuthErrorCode(rawValue:error._code) != nil{
                    print("Error: \(error.localizedDescription)")
                    NotificationCenter.default.post(name:Notification.Name(rawValue:"loginfailed"),object:nil,userInfo:nil)
                }
                return
            }
            DispatchQueue.main.async {
            NotificationCenter.default.post(name:Notification.Name(rawValue:"logintriggered"),object:nil,userInfo:nil)
            }
            
        }
        
    }
    
    //boilerplate code that is used to access firebase authentication system to create user account
    func createAccount(email:String,password:String){
        Auth.auth().createUser(withEmail:email,password:password){(authResult,error) in
            if let error = error {
                if AuthErrorCode(rawValue:error._code) != nil{
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            DispatchQueue.main.async{
            print("Here0")
                NotificationCenter.default.post(name:Notification.Name(rawValue:"signupCompleting"),object:nil,userInfo:nil)
            }
            
        }
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "UserInfo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
   /* func addTestData(){
        guard let entity  = NSEntityDescription.entity(forEntityName: "UserData", in: managedObjectContext)else{
            fatalError("Could Not Find Entity")
        }
        let user = NSManagedObject(entity:entity, insertIntoManagedObjectContext:managedObjectContext)
        user.setValue("David", forKey: "user")
        user.setValue(24.0, forKey:"bmi")
        user.setValue(0.03, forKey:"bac")
    }
    */
    
    
    //Creates record within CoreData Model
   /* func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject?
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        
        return result
    }
    func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    //Deletes all data stored in CoreData Object
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }
    
    func fetchManipulate(in entity: String, StringinManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject]{
         let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        // Helpers
        var list: NSManagedObject? = nil
        
        // Fetch List Records
        let lists = fetchRecordsForEntity("UserData", inManagedObjectContext: context)
        
        if let listRecord = lists.first {
            list = listRecord
        } else if let listRecord = createRecordForEntity("UserData", inManagedObjectContext: context) {
            list = listRecord
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
        return lists
    }*/
    /*let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
    //request.predicate = NSPredicate(format: "age = %@", "12")
    request.returnsObjectsAsFaults = false
    do {
    let result = try context.fetch(request)
    for data in result as! [NSManagedObject] {
    print(data.value(forKey: "username") as! String)
    }
    
    } catch {
    
    print("Failed")
    }
    */
    
    // removes all user data stored persistantly when user logs out
    func removeUserData(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
}

