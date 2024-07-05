//
//  ListOfRecipeViewController.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 31/03/2024.
//

import UIKit

class ListOfRecipeViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties

    var recipesList = [Recipe]()
    let RecipeCellIdentifier = "RecipeCellIdentifier"
    let loader = RecipesLoader()
    var ingredientsRecipe: [String] = []
    var ingredients: [String] = []
    var lastRecipe: Int = 0
    var imageCache = NSCache<NSString, UIImage>()
    var segue: String = ""
    
    var selectedRecipe: RecipeRepresentable?


    var currentPage = 1
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

        loadRecipes(from: 0, to: 10)

        recipeTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeTableView.reloadData()
    }

    func loadRecipes(from: Int, to: Int) {
        isLoading = true

        loader.fetchRecipes(ingredients: ingredients, from: from, to: to) { result in
            switch result {
            case .success(let data):
                self.recipesList += data.hits.map { $0.recipe }
                self.lastRecipe += 10
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            self.isLoading = false
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height * 2 {
            if !isLoading {
                currentPage += 1
                let from = lastRecipe + 1
                let to = lastRecipe + 10
                loadRecipes(from: from, to: to)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RecipeViewController {
            controller.recipe = selectedRecipe
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = RecipeRepresentable(recipe: recipesList[indexPath.row])
        performSegue(withIdentifier: "showDetailRecipe", sender: nil)
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

        cell.configure(with: RecipeRepresentable(recipe: recipe))

        return cell
    }
}
