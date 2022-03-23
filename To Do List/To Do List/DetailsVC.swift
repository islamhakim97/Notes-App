//
//  DetailsVC.swift
//  To Do List
//
//  Created by Islam Abd El Hakim on 18/02/2022.
//

import UIKit

class DetailsVC: UIViewController {
    var todo:Todo!
    var index :Int!
    @IBOutlet weak var DetailsImageView: UIImageView!
    @IBOutlet weak var DetailsTitleLabel: UILabel!
    @IBOutlet weak var DetailsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if todo.image != nil
        {
        DetailsImageView.image=todo.image
        }
        else
        { DetailsImageView.image = UIImage(named: "img3")}
        DetailsTitleLabel.text=todo.title
        DetailsLabel.text=todo.details
        // subscripe to editedItem notification
        NotificationCenter.default.addObserver(self, selector: #selector(detailsEdited), name: NSNotification.Name(rawValue: "editItem"), object: nil)
    }
    
    @IBAction func editTodobtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "editDetailsid") as! NewTodoVC
        vc.isCreation = false
        vc.newToDo=todo
        vc.editedIndexPath = index
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func detailsEdited(notification:Notification)
    {
        if let todo = notification.userInfo!["editedToDo"] as? Todo
        {
            DetailsImageView.image = todo.image
            DetailsTitleLabel.text=todo.title
            DetailsLabel.text=todo.details
        }
    }
    @IBAction func deleteTodoBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "تنبيه", message: "هل انت متاكد من حذف المهمه؟", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "تاكيد الحذف", style: .destructive) { alert in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "todoDeletedItem"), object: nil, userInfo: ["todoDeletedIndex":self.index])
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "اغلاق", style:.cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

    

    


