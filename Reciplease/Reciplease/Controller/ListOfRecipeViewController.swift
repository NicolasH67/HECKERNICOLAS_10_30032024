//
//  ListOfRecipeViewController.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 31/03/2024.
//

import UIKit
import Alamofire

class ListOfRecipeViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipesList = [Recipe]()
    let RecipeCellIdentifier = "RecipeCellIdentifier"
    let loader = RecipesLoader()
    // MARK: - IBOutlet
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipeTableView.register(nib, forCellReuseIdentifier: RecipeCellIdentifier)
        recipeTableView.reloadData()
        recipeTableView.rowHeight = 150
        
        loader.fetchRecipes(ingrediants: ["Beef"]) { result in
            switch result {
            case .success(let data):
                self.recipesList = data.hits.map { $0.recipe }
                
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeTableView.reloadData()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Image download failed: \(error)")
                completion(nil)
            }
        }
    }
}

extension ListOfRecipeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(recipesList.count)
        return recipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCellIdentifier, for: indexPath) as? RecipeTableViewCell else {
            fatalError("Failed to dequeue a RecipeTableViewCell.")
        }
            
        let recipe = recipesList[indexPath.row]
        
        if let imageUrl = URL(string: recipe.image) {
            downloadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    let imageView = UIImageView(frame: cell.contentView.bounds)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    imageView.image = image
                    
                    cell.contentView.addSubview(imageView)
                    cell.contentView.sendSubviewToBack(imageView)
                }
            }
        }
        
        cell.recipeTableViewCellUILabel.text = recipe.label
        return cell
    }
}
