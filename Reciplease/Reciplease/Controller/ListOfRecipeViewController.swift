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
    var activityIndicator: UIActivityIndicatorView!

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

        setupActivityIndicator()
        loadRecipes(from: 0, to: 10)

        recipeTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeTableView.reloadData()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        let size: CGFloat = 100
        activityIndicator.frame = CGRect(x: 0, y: 0, width: size, height: size)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    func loadRecipes(from: Int, to: Int) {
        isLoading = true
        activityIndicator.startAnimating()

        loader.fetchRecipes(ingredients: ingredients, from: from, to: to) { result in
            switch result {
            case .success(let data):
                self.recipesList += data.hits.map { $0.recipe }
                self.lastRecipe += 10
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
                }
            case .failure(_):
                self.showEmptyListAlert(message: "There is a problem with the server", title: "Server error")
            }
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if self.recipesList.isEmpty {
                    print("list is emptye")
                    self.showEmptyListAlert(message: "Please go back and try different ingredients.", title: "No Recipes Found")
                }
            }
        }
    }
    
    func showEmptyListAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
