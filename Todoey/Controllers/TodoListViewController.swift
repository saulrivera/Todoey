//
//  ViewController.swift
//  Todoey
//
//  Created by Saul Rivera on 05/04/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var category: Category? {
        didSet {
            self.title = category?.name
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = UIColor(hexString: category!.color) {
             let contrastColour = ContrastColorOf(colorHex, returnFlat: true)
            
            let app = UINavigationBarAppearance()
            app.backgroundColor = colorHex
            app.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColour]
            navigationController?.navigationBar.scrollEdgeAppearance = app
            
            navigationController?.navigationBar.tintColor = contrastColour
            
            searchBar.barTintColor = colorHex
        }
    }
    
    // MARK: - Table View Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            let colour = UIColor(hexString: category!.color)?.darken(byPercentage: {
                CGFloat(indexPath.row) / CGFloat(self.todoItems!.count)
            }())
            
            if let colour = colour {
                let contrastedColor = ContrastColorOf(colour, returnFlat: true)
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = contrastedColor
                cell.tintColor = contrastedColor
            }
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added yet"
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            try realm.write {
                let item = self.todoItems![indexPath.row]
                realm.delete(item)
            }
        } catch {
            print("Error while deliting item \(error)")
        }
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    tableView.reloadData()
                }
            } catch {
                print("Error saving items, \(error)")
            }
        }
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextFiel) in
            alertTextFiel.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak alert] (_) in
            if let data = alert?.textFields?[0].text, let selectedCategory = self.category {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = data
                        newItem.dateCreated = Date()
                        selectedCategory.items.append(newItem)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving items, \(error)")
                }
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionCancel)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
  
    // MARK: - Conext Cycle Methods
    
    func loadItems() {
        todoItems = category?.items
            .sorted(byKeyPath: "title", ascending: true)
    }
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = category?.items
            .filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
