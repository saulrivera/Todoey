//
//  ViewController.swift
//  Todoey
//
//  Created by Saul Rivera on 05/04/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    // MARK: - Table View Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = itemArray[indexPath.row]
        item.done = !item.done
        saveItems()
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextFiel) in
            alertTextFiel.placeholder = "Create new item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak alert] (action) in
            if let data = alert?.textFields?[0].text {
                let newItem = Item(context: self.context)
                newItem.title = data
                newItem.done = false
                self.itemArray.append(newItem)
                
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching")
        }
    }
}

