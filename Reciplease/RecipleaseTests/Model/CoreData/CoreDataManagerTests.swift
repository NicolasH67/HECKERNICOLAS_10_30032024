//
//  CoreDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Nicolas Hecker on 18/07/2024.
//

import XCTest
import CoreData
@testable import Reciplease

final class CoreDataManagerTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var recipeModel: CoreDataManager!
    
    let recipe = Recipe(
        label: "Recipe Test",
        image: "www.testUrl.fr",
        shareAs: "www.testUrl.fr",
        ingredients: [Ingredient(text: "ingredients1", quantity: 0.0, measure: nil, food: "ingredients", weight: 0.0, foodCategory: "food", foodID: "0", image: nil)],
        calories: 30.99,
        totalTime: 43
    )

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let persistentContainer = NSPersistentContainer(name: "Reciplease")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { description, error in
            XCTAssertNil(error)
        }
        
        context = persistentContainer.viewContext
        recipeModel = CoreDataManager(context: context)
    }

    override func tearDownWithError() throws {
        context = nil
        recipeModel = nil
        try super.tearDownWithError()
    }

    func testLoadRecipes() throws {
        recipeModel.addToFavorite(for: RecipeRepresentable(recipe: recipe))
        
        let recipes = try recipeModel.loadRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.label, "Recipe Test")
    }
    
    func testCheckFavoriteStatusEqualTrue() throws {
        recipeModel.addToFavorite(for: RecipeRepresentable(recipe: recipe))
        
        let isFavorite = try recipeModel.checkFavoriteStatus(for: recipe.label)
        
        XCTAssertTrue(isFavorite)
    }
    
    func testCheckFavoriteStatusEqualFalse() throws {
        let recipeLabel = "Test Recipe"
        
        let isFavorite = try recipeModel.checkFavoriteStatus(for: recipeLabel)
        
        XCTAssertFalse(isFavorite)
    }
    
    func testRemoveToFavoriteSuccess() throws {
        recipeModel.addToFavorite(for: RecipeRepresentable(recipe: recipe))
        
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "label == %@", recipe.label)
        
        var results = try context.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1)
        
        recipeModel.removeToFavorite(for: recipe.label)
        
        results = try recipeModel.loadRecipes()
        XCTAssertEqual(results.count, 0)
    }
    
    func testRemoveToFavoriteFail() throws {
        recipeModel.addToFavorite(for: RecipeRepresentable(recipe: recipe))
        
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "label == %@", recipe.label)
        
        var results = try context.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1)
        
        recipeModel.removeToFavorite(for: "recipeLabel")
        
        results = try context.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1)
    }
    
    func testAddToFavorite() throws {
        recipeModel.addToFavorite(for: RecipeRepresentable(recipe: recipe))
        
        let recipes = try recipeModel.loadRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.label, recipe.label)
        XCTAssertEqual(recipes.first?.calories, recipe.calories)
        XCTAssertEqual(recipes.first?.time, Int32(recipe.totalTime))
        XCTAssertEqual(recipes.first?.ingredients?.first, recipe.ingredients.first?.text)
        XCTAssertEqual(recipes.first?.shareAs, recipe.shareAs)
    }
}
