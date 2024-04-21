//
//  RecipesResponses.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 16/04/2024.
//

import Foundation

// MARK: - RecipesResponses
struct RecipesResponses: Decodable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Decodable {
    let uri: String
    let label: String
    let image: String
    let source: String
    let url: String
    let shareAs: String
    let yield: Int
    let dietLabels: [DietLabel]
    let healthLabels: [String]
    let cautions: [Caution]
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories, totalWeight: Double
    let totalTime: Int
    let cuisineType: [CuisineType]
    let mealType: [MealType]
    let dishType: [DishType]
    let totalNutrients, totalDaily: [String: Total]
    let digest: [Digest]
    let tags: [String]?
}

enum Caution: String, Decodable {
    case gluten = "Gluten"
    case sulfites = "Sulfites"
    case wheat = "Wheat"
}

enum CuisineType: String, Decodable {
    case american = "american"
    case british = "british"
}

enum DietLabel: String, Decodable {
    case balanced = "Balanced"
    case highFiber = "High-Fiber"
    case lowSodium = "Low-Sodium"
}

// MARK: - Digest
struct Digest: Decodable {
    let label, tag: String
    let schemaOrgTag: SchemaOrgTag?
    let total: Double
    let hasRDI: Bool
    let daily: Double
    let unit: Unit
    let sub: [Digest]?
}

enum SchemaOrgTag: String, Decodable {
    case carbohydrateContent = "carbohydrateContent"
    case cholesterolContent = "cholesterolContent"
    case fatContent = "fatContent"
    case fiberContent = "fiberContent"
    case proteinContent = "proteinContent"
    case saturatedFatContent = "saturatedFatContent"
    case sodiumContent = "sodiumContent"
    case sugarContent = "sugarContent"
    case transFatContent = "transFatContent"
}

enum Unit: String, Decodable {
    case empty = "%"
    case g = "g"
    case kcal = "kcal"
    case mg = "mg"
    case µg = "µg"
}

enum DishType: String, Decodable {
    case cereals = "cereals"
    case desserts = "desserts"
    case starter = "starter"
}

// MARK: - Ingredient
struct Ingredient: Decodable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let foodCategory, foodID: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}

enum MealType: String, Decodable {
    case breakfast = "breakfast"
    case lunchDinner = "lunch/dinner"
    case teatime = "teatime"
}

// MARK: - Total
struct Total: Decodable {
    let label: String
    let quantity: Double
    let unit: Unit
}

