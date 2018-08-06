//
//  ViewController.swift
//  Todoey
//
//  Created by Bibhuti Anand on 8/2/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet var searchBar: UITableView!
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItemsFromCoreData()
        }
    }
    //let defaults = UserDefaults.standard
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataFilePathForCoreDataStorage = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePathForCoreDataStorage)
        
        //searchBar.delegate = self
        
        
       // loadItems()
        loadItemsFromCoreData()
        
        
        
        //Fetching the data from userdefaults to display on the view
//        if let items = (defaults.array(forKey: "ToDoListArray") as? [Item]) {
//            itemArray = items
//        }
        
//        let newItem = Item()
//        newItem.title = "Find Me"
//
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Haters!"
//        itemArray.append(newItem3)
        
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType =  item.done ? .checkmark : .none
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - Tableview Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].done)
        print(itemArray[indexPath.row].title)
        
        //        if (itemArray[indexPath.row]).done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        //We can write the following one line as an alternative for the above if else logic
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        updating values in coredata
//        context.setValue("Completed", forKey: "title")
        
        //delete operation on core data
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
            saveItems() //Saving the value of done to the Items.plist
        
        
        
        //        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        //
        //Forces the tableview to reload its data source methods
        //tableView.reloadData()
        //To avoid gray color of selected cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Items", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks add item button on the alert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems() //Saving data
            
            
        }
        //adding text field to alert view controller
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItems() {
//
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("error in encoding data \(error)")
//        }
//        tableView.reloadData()
//    }
    //saving the items using the core data
    func saveItems() {
        
        do {
            try context.save()
            
        } catch {
            print("error in saving data \(error)")
        }
        tableView.reloadData()
    }
    
//    func loadItems() {
//
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print(error)
//            }
//        }
//    }
    
    func loadItemsFromCoreData( with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = predicate
        }
        
        
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("error in fetching data \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - SeachBar  methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItemsFromCoreData(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if (searchBar.text?.count == 0) {
            print("here")
            loadItemsFromCoreData()
            
            DispatchQueue.main.async {
                print("inside")
                searchBar.resignFirstResponder()
                
            }
        }
    }
}
















