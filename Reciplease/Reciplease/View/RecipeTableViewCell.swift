//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 02/04/2024.
//

import UIKit

struct RecipeRepresentable {
    var recipeTitle: String
    var ingredients: [String]?
    var image: String?
    var shareAs: String?
    
    init(recipeEntity: RecipeEntity) {
        self.recipeTitle = recipeEntity.label ?? ""
        self.ingredients = recipeEntity.ingredients
        self.image = recipeEntity.image
        self.shareAs = recipeEntity.shareAs
    }
    
    init(recipe: Recipe) {
        self.recipeTitle = recipe.label
        self.ingredients = recipe.ingredients.map { $0.text}
        self.image = recipe.image
        self.shareAs = recipe.shareAs
    }
}

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeTableViewCellUILabel: UILabel!
    @IBOutlet weak var recipeIngrediantTableViewCellUILabel: UILabel!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeContentView: UIView!
    
    var recipeTitle: String?
    var ingredients: [String]?
        
    func configure(with recipe: RecipeRepresentable) {
        if let recipeTitleLabel = recipeTableViewCellUILabel {
            recipeTitleLabel.text = recipe.recipeTitle
        }
        recipeTableViewCellUILabel.text = recipe.recipeTitle
        guard let imageUrl = recipe.image else { return }
        loadImage(url: imageUrl)
        recipeIngrediantTableViewCellUILabel.text = recipe.ingredients?.joined(separator: ", ")
    }
    
    func loadImage(url: String) {
        if let imageUrl = URL(string: url) {
            ImageLoader.downloadImage(from: imageUrl) { imageData in
                if let data = imageData, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.recipeImageView?.image = image
                        self.recipeImageView?.contentMode = .scaleAspectFit
                        self.recipeImageView?.clipsToBounds = true
                    }
                }
            }
        }
    }
}
