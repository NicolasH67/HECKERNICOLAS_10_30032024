//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 31/03/2024.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    var recipe: RecipeRepresentable?
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var favoriteBarButtomItem: UIBarButtonItem!
    
    @IBAction func getDirectionsButtonAction(_ sender: Any) {
        if let shareAs = recipe?.shareAs, let url = URL(string: shareAs) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("error")
            }
        }
    }
    
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        let starImage = UIImage(systemName: "star")
        let starFilledImage = UIImage(systemName: "star.fill")
        if sender.image == starImage {
            sender.image = starFilledImage
            addToFavorite()
        } else {
            sender.image = starImage
            removeToFovrite(title: recipe!.recipeTitle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFavoriteStatus()
        if let recipeTitle = recipe?.recipeTitle {
            recipeTitleLabel.text = recipeTitle
        }
        
        if let recipeIngredients = recipe?.ingredients {
            print(recipeIngredients)
        }
        
        if let imageUrlString = recipe?.image, let imageUrl = URL(string: imageUrlString) {
            ImageLoader.downloadImage(from: imageUrl) { imageData in
                if let data = imageData, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.setBackgroundImage(image, for: self.imageView)
                    }
                }
            }
        }
    }
    
    func setBackgroundImage(_ image: UIImage, for view: UIView) {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = view.bounds
        backgroundLayer.contents = image.cgImage
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    func checkFavoriteStatus() {
        guard let recipeLabel = recipe?.recipeTitle else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        request.predicate = NSPredicate(format: "label == %@", recipeLabel)
        
        do {
            let results = try context.fetch(request)
            
            if results.first != nil {
                favoriteBarButtomItem.image = UIImage(systemName: "star.fill")
            } else {
                return
            }
        } catch {
            return
        }
    }
    
    func addToFavorite() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let recipeEntity = RecipeEntity(context: context)
        recipeEntity.label = recipe?.recipeTitle
        recipeEntity.image = recipe?.image
        recipeEntity.ingredients = recipe?.ingredients as? [String]
        recipeEntity.shareAs = recipe?.shareAs
        appDelegate.saveContext()
    }
    
    func removeToFovrite(title : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        request.predicate = NSPredicate(format: "label == %@", title)
        
        do {
            let results = try context.fetch(request)
            
            if let recipeToDelete = results.first {
                context.delete(recipeToDelete)
                
                try context.save()
            } else {
                print("No recipe found with the title \(title)")
            }
        } catch {
            print("Failed to fetch or delete the recipe: \(error)")
        }
    }
}

extension RecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        if let ingredient = recipe?.ingredients?[indexPath.row] {
            cell.textLabel?.text = ingredient
        }
        return cell
    }
}
