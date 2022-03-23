//
//  NewTodoVC.swift
//  To Do List
//
//  Created by Islam Abd El Hakim on 18/02/2022.
//

import UIKit

class NewTodoVC: UIViewController {
    var newToDo:Todo?
    var isCreation = true
    var editedIndexPath:Int?
    
    @IBOutlet weak var newTodoTitletextField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var newTodoDetails: UITextView!
    @IBOutlet weak var mainbtn: UIButton!
    @IBOutlet weak var addimgBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isCreation
        {
            navigationItem.title = "تعديل المهمه"
            mainbtn.setTitle("تعديل", for: .normal)
            addimgBtn.setTitle("تعديل الصوره", for: .normal)
            newTodoTitletextField.text=newToDo?.title
            newTodoDetails.text=newToDo?.details
            imgView.image = newToDo?.image

        }
            
    }
    
    @IBAction func addMissionBtn(_ sender: Any) {
        if isCreation
        {
            newToDo=Todo(title: newTodoTitletextField.text!, image: imgView.image, details: newTodoDetails.text)
            // passing data
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"newToDoAdded") , object: nil, userInfo: ["newTodo":newToDo])
            let alert = UIAlertController(title: "تم", message: "تم الاضافه بنجاح", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: " تم ", style: .default, handler:{_ in
                self.tabBarController?.selectedIndex = 0
            })
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
            })
            setupUI()
        }
        else
        {
            //the view controller come from edit View Controller
            newToDo=Todo(title: newTodoTitletextField.text!, image: newToDo?.image, details: newTodoDetails.text)
            // post a notification with edited item
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editItem"), object: nil, userInfo: ["editedToDo":newToDo,"editedIndex":editedIndexPath])
            let alert = UIAlertController(title: "تم التعديل", message: "تم تعديل المهمه بنجاح", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: " تم  ", style: .default, handler:{_ in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(closeAction)
            present(alert, animated: true, completion: {
            })
            setupUI()
            
        }
    }
   
    @IBAction func addimgBtn(_ sender: Any) {
        let picker=UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing=true
        
        present(picker, animated: true, completion: nil)
    }
    func setupUI()
    {
        newTodoTitletextField.text=""
        newTodoDetails.text=""
        imgView.image = nil
    }
   
}
extension NewTodoVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let image=info[.editedImage]  as? UIImage
        imgView.image = image
        newToDo?.image = image
    }
}

