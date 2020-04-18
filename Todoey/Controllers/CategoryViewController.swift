//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Saul Rivera on 17/04/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Category name"
        }
        
        let action = UIAlertAction(title: "Ok", style: .default) { [weak alert] (alertAction) in
            if let text = alert?.textFields![0].text {
                let category = Category(context: self.context)
                category.name = text
                
                self.categories.append(category)
                
                self.saveContext()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Context source methods
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching categories")
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context")
        }
    }
    
    // MARK: - Segue transition
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySelected = categories[indexPath.row]
        
        performSegue(withIdentifier: "goToItems", sender: categorySelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TodoListViewController
        vc.category = sender as? Category
    }

}
