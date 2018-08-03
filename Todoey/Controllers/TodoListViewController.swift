//
//  ViewController.swift
//  Todoey
//
//  Created by Bibhuti Anand on 8/2/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath!)
        
        //Fetching the data from userdefaults to display on the view
//        if let items = (defaults.array(forKey: "ToDoListArray") as? [Item]) {
//            itemArray = items
//        }
        
        let newItem = Item()
        newItem.title = "Find Me"
        
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Haters!"
        itemArray.append(newItem3)
        
        
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
        
            saveItems() //Saving the value of done to the Items.plist
        
        
        
        //        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        //
        //Forces the tableview to reload its data source methods
        tableView.reloadData()
        //To avoid gray color of selected cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Items", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks add item button on the alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.saveItems() //Saving data to Items.plist
            
            
        }
        //adding text field to alert view controller
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error in encoding data \(error)")
        }
        tableView.reloadData()
    }
}

