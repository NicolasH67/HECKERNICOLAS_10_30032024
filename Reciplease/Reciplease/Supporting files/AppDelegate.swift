//
//  AppDelegate.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 30/03/2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        _ = try? persistentContainer.viewContext.fetch(request)
        
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = UIColor.white
        
        return true
    }
    
    // MARK: - Core Data stack

       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "Reciplease")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
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
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
}

