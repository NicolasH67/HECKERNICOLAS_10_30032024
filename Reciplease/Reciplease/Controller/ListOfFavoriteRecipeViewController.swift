//
//  ViewController.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 23/05/2024.
//

import UIKit
import CoreData

class ListOfFavoriteRecipeViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties

    var recipesList = [RecipeEntity]()
    let RecipeCellIdentifier = "RecipeCellIdentifier"
    var ingredientsRecipe: [String] = []
    
    var selectedRecipe: RecipeRepresentable?

    var isLoading = false

    // MARK: - IBOutlet

    @IBOutlet weak var recipeTableView: UITableView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        recipeTableView.register(nib, forCellReuseIdentifier: RecipeCellIdentifier)
        recipeTableView.reloadData()
        recipeTableView.rowHeight = 150
        recipeTableView.delegate = self
        
        loadRecipes()
        
        recipeTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecipes()
        recipeTableView.reloadData()
    }

    func loadRecipes() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let loader = CoreDataManager(context: context)
        
        loader.loadRecipes()
        
        recipesList = loader.recipesList
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RecipeViewController {
            controller.recipe = selectedRecipe
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = RecipeRepresentable(recipeEntity: recipesList[indexPath.row])
        performSegue(withIdentifier: "showDetailRecipe", sender: nil)
    }
}

extension ListOfFavoriteRecipeViewController: UITableViewDataSource {
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

        cell.configure(with: RecipeRepresentable(recipeEntity: recipe))

        return cell
    }
}
