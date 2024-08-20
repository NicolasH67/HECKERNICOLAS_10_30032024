//
//  HomeViewController.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 30/03/2024.
//

import UIKit

class HomeViewController: UIViewController {
    static var cellIdentifier = "IngrediantCell"
    var ingrediants: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipe" {
            if let destinationVC = segue.destination as? ListOfRecipeViewController {
                destinationVC.segue = "showRecipe"
                destinationVC.ingredients = ingrediants
            }
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var ingrediantsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    @IBAction func clearButton(_ sender: Any) {
        clearIngredients()
        ingrediantsTextField.resignFirstResponder()
        UIAccessibility.post(notification: .announcement, argument: "All ingredient cleared")
    }
    
    @IBAction func addButton(_ sender: Any) {
        addIngredients()
        ingrediantsTextField.resignFirstResponder()
        
        if let ingredientText = ingrediantsTextField.text, !ingredientText.isEmpty {
            UIAccessibility.post(notification: .announcement, argument: "Ingredient \(ingredientText) added")
        }
    }
    
    @IBAction func dissmissKeybord(_ sender: UITapGestureRecognizer) {
        ingrediantsTextField.resignFirstResponder()
    }
    
    @IBAction func searchRecipeButton(_ sender: Any) {
        UIAccessibility.post(notification: .announcement, argument: "Searching for recipes")
    }
    
    // MARK: - function
    
    private func addIngredients() {
        if let ingredientText = ingrediantsTextField.text, !ingredientText.isEmpty {
            ingrediants.append(ingredientText)
            ingrediantsTextField.text = ""
            tableView.reloadData()
        }
    }
    
    private func clearIngredients() {
        ingrediants.removeAll()
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingrediants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.cellIdentifier, for: indexPath)
        let ingredient = ingrediants[indexPath.row]

        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.text = ingredient
        
        cell.accessibilityLabel = "Ingredient \(ingredient)"
        cell.accessibilityTraits = .staticText

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedIngredient = ingrediants[indexPath.row]
            ingrediants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Notification d'accessibilité pour informer de la suppression d'un ingrédient
            UIAccessibility.post(notification: .announcement, argument: "Ingredient \(removedIngredient) deleted")
        }
    }
}
