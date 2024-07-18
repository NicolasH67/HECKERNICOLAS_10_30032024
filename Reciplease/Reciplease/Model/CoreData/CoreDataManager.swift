//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 05/07/2024.
//

import Foundation
import CoreData

class CoreDataManager {
    var recipesList: [RecipeEntity] = []
    
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadRecipes() {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
        do {
            let recipes = try context.fetch(fetchRequest)
            recipesList = recipes
        } catch {
            print("Failed to fetch recipes: \(error.localizedDescription)")
        }
    }
    
    func checkFavoriteStatus(for recipeLabel: String) -> Bool {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        request.predicate = NSPredicate(format: "label == %@", recipeLabel)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            #warning("verifier le print")
            print("Error fetching favorite status: \(error.localizedDescription)")
            return false
        }
    }
    
    func addToFavorite(for recipe: RecipeRepresentable?) {
        let recipeEntity = RecipeEntity(context: context)
        recipeEntity.label = recipe?.recipeTitle
        recipeEntity.image = recipe?.image
        recipeEntity.calories = recipe?.calorie ?? 0.0
        recipeEntity.time = Int32(recipe?.time ?? 0)
        recipeEntity.ingredients = recipe?.ingredients as? [String]
        recipeEntity.shareAs = recipe?.shareAs
        try? context.save()
    }
    
    func removeToFavorite(for recipeLabel: String) {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        
        request.predicate = NSPredicate(format: "label == %@", recipeLabel)
        
        do {
            let results = try context.fetch(request)
            
            if let recipeToDelete = results.first {
                context.delete(recipeToDelete)
                
                try context.save()
            } else {
                print("No recipe found with the title \(recipeLabel)")
            }
        } catch {
            print("Failed to fetch or delete the recipe: \(error)")
        }
    }
}
