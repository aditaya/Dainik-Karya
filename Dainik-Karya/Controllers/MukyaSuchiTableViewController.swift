//
//  MukyaSuchiTableViewController.swift
//  Dainik-Karya
//
//  Created by Vineet Mahali on 16/07/20.
//  Copyright © 2020 Aditaya Rana. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class MukyaSuchiTableViewController: SwipeTableViewController {

    
    var realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
       
    }

    override func viewWillAppear(_ animated: Bool) {
    
        guard let navBar = (navigationController?.navigationBar) else {
            fatalError("Navigation Controller doesn't exist")
            }
        
        navBar.backgroundColor = UIColor(hexString: "00B06B")
    }

// MARK: - Database or Data Manipulation Method
    
    func loadCategories() {
         
        categories = realm.objects(Category.self)
             tableView.reloadData()
        
     
    }
    
    
    func save(category: Category ) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error in Saving Category \(error)")
        }
        tableView.reloadData()
    }
 
    
    // MARK: - Delete Data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
            if let categoryForDeletion = self.categories?[indexPath.row] {
                        do {
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                        }
                        } catch {
                            print("Error in deletion \(error)")
                        }
                        }
    }
    
    // MARK: - TableView Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        return cell
    }


// MARK: - Add Button Pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Mukhya Karya", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
//            self.categories.append(newCategory)
             self.save(category: newCategory)
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Mukhya Karya"
        }
    
        present(alert, animated: true, completion: nil)
    
    }
    
 // MARK: - TableView Delegate Method
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DainikViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}


