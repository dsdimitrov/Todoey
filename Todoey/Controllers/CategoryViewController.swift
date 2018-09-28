//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dimo Dimitrov on 28.09.18.
//  Copyright © 2018 Dimo Dimitrov. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoryArray = [Category] ()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        print(categoryArray.count)
    }
    //MARK: TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell at row \(indexPath.row) with name \(categoryArray[indexPath.row])")
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       // performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Success")
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()

        }
        
        alert.addTextField { (field) in
            field.placeholder = "Create new category"
            textField = field
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    

    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
            print(categoryArray)
        } catch {
            print("Error loading categories: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
}
