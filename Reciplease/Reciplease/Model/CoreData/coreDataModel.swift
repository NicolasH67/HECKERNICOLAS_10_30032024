//
//  coreDatamModel.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 05/07/2024.
//

import Foundation
import CoreData

class careDataModel {
    
    func checkFavoriteStatus(for recipeLabel: String, appDelegate: AppDelegate) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        request.predicate = NSPredicate(format: "label == %@", recipeLabel)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error fetching favorite status: \(error.localizedDescription)")
            return false
        }
    }
    
}
