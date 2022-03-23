//
//  TodosVC.swift
//  To Do List
//
//  Created by Islam Abd El Hakim on 18/02/2022.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    var todosArr = [Todo]()
   
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        todosTableView.dataSource=self
        todosTableView.delegate=self
        todosArr=todoRetrieveData()
        // Mark:todoAdd item Notification
        NotificationCenter.default.addObserver(self, selector: #selector(addnewTodo), name: NSNotification.Name(rawValue:"newToDoAdded") , object: nil)
        // Mark:todoEdit item Notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoeditItem), name: NSNotification.Name(rawValue:"editItem") , object: nil)
        //Mark:todo Delete item Notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleteItem), name: NSNotification.Name(rawValue:"todoDeletedItem") , object: nil)
    }
    @objc func addnewTodo(notification:Notification)
    {
        if let todo = notification.userInfo!["newTodo"] as? Todo
        {
            todosArr.append(todo )
        
        todosTableView.reloadData()// to rebuild the tableview with the new element added
        // print(notification.userInfo!["newTodo"])
        todoSroreData(todo:todo) // save todo in coreData
        }
    }
    @objc func todoeditItem(notification:Notification)
    {
        if let todo = notification.userInfo!["editedToDo"] as? Todo
        {
            if let editedindex = notification.userInfo!["editedIndex"] as? Int
            {
                todosArr[editedindex]=todo
                todoUpdateData(index: editedindex, todo: todo)// update To Do Recored in Core Data
            }
            todosTableView.reloadData()
        }
    }
    @objc func todoDeleteItem(notification:Notification)
    {
        if let deletedindex = notification.userInfo!["todoDeletedIndex"] as? Int
        {
            todosArr.remove(at: deletedindex)
            todoDeleteData(index: deletedindex)
        }
        todosTableView.reloadData()
    }
    
    
}
extension TodosVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell") as! ToDoCell
        cell.toDoTitleLabel.text = todosArr[indexPath.row].title
        if todosArr[indexPath.row].image != nil
        {
            cell.toDoImg.image = todosArr[indexPath.row].image
        }
        else
        {
            cell.toDoImg.image=UIImage(named: "img0")
        }
        // to make img radius
        cell.toDoImg.layer.cornerRadius = cell.toDoImg.frame.width/2
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC =  storyboard?.instantiateViewController(withIdentifier: "detailsId")as! DetailsVC
        detailsVC.todo = todosArr[indexPath.row]
        detailsVC.index = indexPath.row
        navigationController?.pushViewController(detailsVC, animated: true)
        
    }
    
}
// Extenstion for using CoreData For CRUD 
extension TodosVC
{
    func todoSroreData(todo :Todo)
    {
       guard let appDelegate = UIApplication.shared.delegate as?AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext) else{return}
        let todoRecord = NSManagedObject(entity: todoEntity, insertInto: managedContext)
        todoRecord.setValue(todo.title, forKey: "title")
        todoRecord.setValue(todo.details, forKey: "details")
        todoRecord.setValue(todo.image, forKey: "image")
        do
        {
            try managedContext.save()
            print("======== Saved Successfully===========")
            
        }catch let error as NSError
        {
            print(error)
        }
        
    }
    func todoRetrieveData() ->[Todo]
    {
        var todosarray = [Todo]()
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {return []}
        let mangedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")//Build the request
        do
        {
            let todos = try mangedContext.fetch(fetchRequest) as![NSManagedObject] //casting from fetchResultType to NsmangedObject Entity
            for managedObject in todos
            {
                // foreCasting from nsMangedObject Entity To Struct Entity that i can handel in code
                let title = managedObject.value(forKey:"title") as! String
                let image = managedObject.value(forKey:"image") as? UIImage
                let details = managedObject.value(forKey:"details") as! String
                var todo = Todo(title: title, image: image, details: details)
                todosarray.append(todo)
                
            }
            
        }
        catch let error as NSError
        {
            print(error)
            
        }
        
        return todosarray
    }
    func todoDeleteData(index:Int)
    {
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {return}
        let mangedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")//Build the request
        do
        {
            let todos = try mangedContext.fetch(fetchRequest) as![NSManagedObject] //casting from fetchResultType to NsmangedObject Entity
            
            try mangedContext.delete(todos[index])
            try mangedContext.save()
        }
        catch let error as NSError
        {
            print(error)
            
        }
        
    }
    func todoUpdateData(index:Int,todo:Todo)
    {
        guard let appDelegate=UIApplication.shared.delegate as? AppDelegate else {return}
        let mangedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")//Build the request
        do
        {
            let todos = try mangedContext.fetch(fetchRequest) as![NSManagedObject] //casting from fetchResultType to NsmangedObject Entity
            todos[index].setValue(todo.title, forKey: "title")
            todos[index].setValue(todo.details, forKey: "details")
            todos[index].setValue(todo.image, forKey: "image")
            try mangedContext.save()
        }
        catch let error as NSError
        {
            print(error)
            
        }
    }
    
}
