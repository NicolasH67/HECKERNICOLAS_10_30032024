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
    
    var dataModel: CoreDataManager?
    
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
            dataModel?.addToFavorite(for: recipe)
        } else {
            sender.image = starImage
            guard let recipeTitleText = self.recipeTitleLabel.text else { return }
            dataModel?.removeToFavorite(for: recipeTitleText)
        }
    }
    
    let imageLoader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataModel = CoreDataManager(context: appDelegate.persistentContainer.viewContext)
        
        if let recipeTitle = recipe?.recipeTitle {
            recipeTitleLabel.text = recipeTitle
        }
        
        updateFavoriteStatus()
        loadImage()
    }
    
    private func updateFavoriteStatus() {
        guard let recipeTitleText = recipeTitleLabel.text else { return }
        let isFavorite = dataModel?.checkFavoriteStatus(for: recipeTitleText)
        favoriteBarButtomItem.image = UIImage(systemName: isFavorite! ? "star.fill" : "star")
    }
    
    private func loadImage() {
        guard let imageUrlString = recipe?.image, let imageUrl = URL(string: imageUrlString) else {
            setDefaultImage()
            return
        }
        
        imageLoader.fetchImage(from: imageUrl) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.setBackgroundImage(image, for: self.imageView)
                    }
                } else {
                    self.setDefaultImage()
                }
            case .failure:
                self.setDefaultImage()
            }
        }
    }
    
    private func setDefaultImage() {
        guard let image = UIImage(named: "defaultImage") else { return }
        DispatchQueue.main.async {
            self.setBackgroundImage(image, for: self.imageView)
        }
    }
    
    private func setBackgroundImage(_ image: UIImage, for imageView: UIImageView) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        dataModel = CoreDataManager(context: appDelegate.persistentContainer.viewContext)
//        
//        if let recipeTitle = recipe?.recipeTitle {
//            recipeTitleLabel.text = recipeTitle
//        }
//        
//        guard let recipeTitleText = recipeTitleLabel.text else { return }
//        let isFavorite = {
//            return self.dataModel?.checkFavoriteStatus(for: recipeTitleText) ?? false
//        }
//        
//        if isFavorite() {
//            favoriteBarButtomItem.image = UIImage(systemName: "star.fill")
//        } else {
//            favoriteBarButtomItem.image = UIImage(systemName: "star")
//        }
//        
//        if let imageUrlString = recipe?.image, let imageUrl = URL(string: imageUrlString) {
//            ImageLoader.downloadImage(from: imageUrl) { imageData in
//                if let data = imageData, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.setBackgroundImage(image, for: self.imageView)
//                    }
//                }
//            }
//        } else {
//            guard let image = UIImage(named: "defaultImage") else { return }
//            DispatchQueue.main.async {
//                self.setBackgroundImage(image, for: self.imageView)
//            }
//        }
//    }
    
    func setBackgroundImage(_ image: UIImage, for view: UIView) {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = view.bounds
        backgroundLayer.contents = image.cgImage
        view.layer.insertSublayer(backgroundLayer, at: 0)
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
