//
//  HomeViewController.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 30/03/2024.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    static var cellIdentifier = "IngrediantCell"
    var ingrediants: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var ingrediantsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    @IBAction func clearButton(_ sender: Any) {
        clearIngredients()
        ingrediantsTextField.resignFirstResponder()
    }
    @IBAction func addButton(_ sender: Any) {
        addIngredients()
        ingrediantsTextField.resignFirstResponder()
    }
    
    @IBAction func dissmissKeybord(_ sender: UITapGestureRecognizer) {
        ingrediantsTextField.resignFirstResponder()
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

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingrediants.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
