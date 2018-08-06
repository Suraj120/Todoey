//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Bibhuti Anand on 8/5/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: SwipeTableViewController{
    
    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80.0

    }

    //MARK: - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoriesArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
        
    }
    
   //MARK: - Data Manipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error in saving the data \(error)")
        }
        //tableView.reloadData()
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error in fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: Data Updation Method
    
    override func updateData(at indexPath: IndexPath) {
        
        //delete operation on core data
                    self.context.delete(self.categoriesArray[indexPath.row])
                    self.categoriesArray.remove(at: indexPath.row)
                    self.saveCategories()
        
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add Categories", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            newItem.name = textfield.text!
            self.categoriesArray.append(newItem)
            self.saveCategories()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create Categories"
            textfield = alertTextfield
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Delegates methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
}


