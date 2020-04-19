//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Saul Rivera on 17/04/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let color = UIColor(hexString: "#1D9BF6")!
        let contrastedColor = ContrastColorOf(color, returnFlat: true)
        
        let app = UINavigationBarAppearance()
        app.backgroundColor = color
        app.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastedColor]
        navigationController?.navigationBar.scrollEdgeAppearance = app
        
        navigationController?.navigationBar.tintColor = contrastedColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            let colour = UIColor(hexString: category.color)
            
            cell.textLabel?.text = category.name
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour!, returnFlat: true)
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                let category = self.categories![indexPath.row]
                self.realm.delete(category)
            }
        } catch {
            print("Error while deliting category")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Category name"
        }
        
        let action = UIAlertAction(title: "Ok", style: .default) { [weak alert] (alertAction) in
            if let text = alert?.textFields![0].text {
                let category = Category()
                category.name = text
                
                self.save(category: category)
                self.tableView.reloadData()
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionCancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Context source methods
    func loadData() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error while saving context")
        }
    }
    
    // MARK: - Segue transition
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySelected = categories?[indexPath.row]
        
        performSegue(withIdentifier: "goToItems", sender: categorySelected)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TodoListViewController
        vc.category = sender as? Category
    }

}
