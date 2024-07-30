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
        let recipe = Recipe(
            label: "Recipe Test",
            image: "www.testUrl.fr",
            shareAs: "www.testUrl.fr",
            ingredients: [Ingredient(text: "ingredients1", quantity: 0.0, measure: nil, food: "ingredients", weight: 0.0, foodCategory: "food", foodID: "0", image: nil)],
            calories: 30.99,
            totalTime: 43
        )
        
        let testRecipe = RecipeRepresentable(recipe: recipe)

        recipeModel.addToFavorite(for: testRecipe)
        
        let recipes = try recipeModel.loadRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.label, "Recipe Test")
    }
    
    func testCheckFavoriteStatusEqualTrue() throws {
        let recipeLabel = "Test Recipe"
        let recipe = RecipeEntity(context: context)
        recipe.label = recipeLabel
            
        try context.save()
        
        let isFavorite = try recipeModel.checkFavoriteStatus(for: recipeLabel)
        
        XCTAssertTrue(isFavorite)
    }
    
    func testCheckFavoriteStatusEqualFalse() throws {
        let recipeLabel = "Test Recipe"
        
        let isFavorite = try recipeModel.checkFavoriteStatus(for: recipeLabel)
        
        XCTAssertFalse(isFavorite)
    }
    
    func testRemoveToFavoriteSuccess() throws {
        let recipeLabel = "Test Recipe"
        let recipe = RecipeEntity(context: context)
        recipe.label = recipeLabel
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "label == %@", recipeLabel)
        
        var results = try context.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1)
        
        recipeModel.removeToFavorite(for: recipeLabel)
        
        results = try context.fetch(fetchRequest)
        XCTAssertEqual(results.count, 0)
    }
    
    func testRemoveToFavoriteFail() throws {
        let recipeLabel = "Test Recipe"
        let recipe = RecipeEntity(context: context)
        recipe.label = recipeLabel
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "label == %@", recipeLabel)
        
        var results = try context.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1)
        
        recipeModel.removeToFavorite(for: "recipeLabel")
        
        results = try context.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1)
    }
    
    func testAddToFavorite() throws {
        
        let recipe = Recipe(
            label: "Recipe Test",
            image: "www.testUrl.fr",
            shareAs: "www.testUrl.fr",
            ingredients: [Ingredient(text: "ingredients1", quantity: 0.0, measure: nil, food: "ingredients", weight: 0.0, foodCategory: "food", foodID: "0", image: nil)],
            calories: 30.99,
            totalTime: 43
        )
        
        let testRecipe = RecipeRepresentable(recipe: recipe)
        
        recipeModel.addToFavorite(for: testRecipe)
        
        let recipes = try recipeModel.loadRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.label, testRecipe.recipeTitle)
        XCTAssertEqual(recipes.first?.calories, testRecipe.calorie)
        XCTAssertEqual(recipes.first?.time, Int32(testRecipe.time ?? 0))
        XCTAssertEqual(recipes.first?.ingredients, testRecipe.ingredients)
        XCTAssertEqual(recipes.first?.shareAs, testRecipe.shareAs)
    }
}
