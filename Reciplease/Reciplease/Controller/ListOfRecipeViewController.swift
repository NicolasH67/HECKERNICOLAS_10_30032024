//
//  ListOfRecipeViewController.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 31/03/2024.
//

import UIKit

class ListOfRecipeViewController: UIViewController {
    
    // MARK: - Properties
    
    var recipesList = [Recipe]()
    let RecipeCellIdentifier = "RecipeCellIdentifier"
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipeTableView.register(nib, forCellReuseIdentifier: RecipeCellIdentifier)
        recipeTableView.reloadData()
        
        RecipesLoader.fetchRecipes(ingrediants: ["Apple", "Chocolate"]) { result in
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
}

extension ListOfRecipeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCellIdentifier, for: indexPath) as? RecipeTableViewCell else {
            fatalError("Failed to dequeue a RecipeTableViewCell.")
        }
            
        let recipe = recipesList[indexPath.row]
            
        cell.recipeTableViewCellUILabel.text = recipe.label ?? "No Title"
            
        return cell
    }
}
