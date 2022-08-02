//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController  {
    
    var itemArray = [Item]()
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext//проміжна область між app &
                                                                                                          //SQL
    //let defaults = UserDefaults.standard //шось тіпа локальної бази даних тіки не база даних

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
      loadItems()
  
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
    }
    
    //MARK Datasource metods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none//тенарний оператор заміняє те шо внизу
        
//        if itemArray[indexPath.row].done == true{//змінює параметр клітинки Accessory  в маін для вибраної клітинки
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
//
        return cell
    }
    // MARK - TableView Delegate metods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark змінює параметр клітинки Accessory  в маін для вибраної клітинки
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done//оператор NOT змінює поточне значення false/true на протилежне значення (якшо стоїть галочка то воно її зніме і навпаки)
//
//        context.delete(itemArray[indexPath.row])  удаляє елемент з таблиці
//        itemArray.remove(at: indexPath.row)       важливий порядок, спочатку з контекста потім тут

        
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        saveItems()
   
        
        tableView.deselectRow(at: indexPath, animated: true)// подсвічує шо вибрав і убирає фон назад який був
    }
    
    //MARK Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()//перемєнна до якої мають доступ усі клоужери в межах кнопки "addButtonPressed"
                                     //шоб витягнути дані з клоужера в наружу
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        //викликає спливаюче вікно
        let action = UIAlertAction(title: "Add item", style: .default)/*кнопка в спливаючому вікні*/ { action in
                //тут кодиться те шо станеться коли натиснеш кнопку "додати елемент"
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)// добавляє значення в масив
            
            self.saveItems()
            //self.defaults.setValue(self.itemArray, forKey: "TodoListArray")//сохраняєм в базу, "for key" ключ в базі
            
            
           
            
          
        }
        alert.addTextField { alertTextField in//поле для писання в спливаючому вікні
            alertTextField.placeholder = "Create new item"//сірі букви які написані пока не вводиш текст
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    


// MARK - метод сохранєнія і розкодірованіє даних
func saveItems() {
    do{
        try context.save()
    }
    catch{
        print("Error saving contexr\(error)")
    }
    self.tableView.reloadData()//обновляє список хуйні в масиві
}
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Fetch error \(error)")
        }
    }
        
}



extension TodoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()//запит в context
        
        let predicate = NSPredicate(format: "title CONTAINS %@" )
    }

    
}
