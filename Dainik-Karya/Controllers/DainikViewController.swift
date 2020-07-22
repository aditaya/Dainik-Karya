//
//  ViewController.swift
//  Dainik-Karya
//
//  Created by Vineet Mahali on 14/07/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class DainikViewController: SwipeTableViewController     {
    
    var toDoItems: Results<Item>?
    
    var realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        loadItems()
        tableView.rowHeight = 80.0
       
       }
        
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if let colorHex = selectedCategory?.color {
            title = selectedCategory?.name


            guard let navBar = (navigationController?.navigationBar) else {
                fatalError("Navigation Controller doesn't exist")
            }
            if let navBarColor = UIColor(hexString: colorHex) {

            navBar.barTintColor = navBarColor

            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            searchBar.tintColor = navBarColor
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.backgroundColor = UIColor(hexString: selectedCategory!.color)!.darken(byPercentage:
                CGFloat(indexPath.row) /  CGFloat(toDoItems!.count)
            )
            
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            cell.accessoryType = item.done ? .checkmark : .none
            // Ternary Operator ==> value = condition ? valueForTrue : valueForFalse
        }else {
            cell.textLabel?.text = "No Item Added"
            
        }
        return cell
        
    }
    
    // MARK: - TableView delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error Saving in Done Item \(error)")
            }
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: " Add new Dainik Karya", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Karya", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    
                    print("Error saving in new Items \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Karya"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItems() {
        
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error in deleting item \(error)")
            }
        }
        
    }
    
}

extension DainikViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems() 
            
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
}

