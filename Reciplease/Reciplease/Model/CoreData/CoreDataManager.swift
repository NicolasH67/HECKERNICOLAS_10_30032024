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
    
    func loadRecipes() throws -> [RecipeEntity] {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
        return try context.fetch(fetchRequest)
    }
    
    func checkFavoriteStatus(for recipeLabel: String) throws -> Bool {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        request.predicate = NSPredicate(format: "label == %@", recipeLabel)
        
        let recipes = try context.fetch(request)
        
        if recipes.isEmpty {
            return false
        }
        return true
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
        
        guard let results = try? context.fetch(request) else { return }
        
        guard let recipeToDelete = results.first else { return }
        
        context.delete(recipeToDelete)
        
        try? context.save()
    }
}
