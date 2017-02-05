//
//  AddTaskViewController.swift
//  ios-daily-tasks
//
//  Created by Николай on 04.02.17.
//  Copyright © 2017 Николай. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITextViewDelegate {

    var navigationTitle : String!
    
    let placeholderString = "Description"
    var textViewDefaultTextColot : UIColor?
    let textViewPlaceholderTextColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.2)
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var lblTaskTitile: UITextField!
    @IBOutlet weak var addTaskNavigationBar: UINavigationItem!
    var btnDone : UIBarButtonItem!
    
//    weak var taskListController: TaskListViewController!
//    var selectedTaskIndex: Int?
    
    weak var selectedTask: DailyTaskMO!
    weak var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                  target: self,
                                  action: #selector(AddTaskViewController.done))
        addTaskNavigationBar.rightBarButtonItems = [btnDone]
        
        taskDescriptionTextView.delegate = self
        taskDescriptionTextView.layer.borderWidth = 1.0
        taskDescriptionTextView.layer.borderColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        taskDescriptionTextView.layer.cornerRadius = 5
        taskDescriptionTextView.clipsToBounds = true
        
        textViewDefaultTextColot = taskDescriptionTextView.textColor
        taskDescriptionTextView.text = placeholderString
        taskDescriptionTextView.textColor = textViewPlaceholderTextColor
        
        addTaskNavigationBar.title = navigationTitle
        
//        taskDescriptionTextView.contentOffset = CGPoint(x: 0, y: 0)
        
        lblTaskTitile.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if navigationTitle == "Edit task" {
//            let index = taskListController.tasksTableView.indexPathForSelectedRow?.row
//            let taskList = taskListController.taskList
//            taskDescriptionTextView.text = taskList?[index!].taskDescription
//            lblTaskTitile.text = taskList?[index!].taskName
//        }
        
//        if let taskIndex = selectedTaskIndex {
//            let taskList = taskListController.taskList
//            lblTaskTitile.text = taskList?[taskIndex].taskName
////            taskDescriptionTextView.text = taskList?[taskIndex].taskDescription
//            if let taskDescription = taskList?[taskIndex].taskDescription {
//                taskDescriptionTextView.textColor = textViewDefaultTextColot
//                taskDescriptionTextView.text = taskDescription
//            }
//        }
        
        if let task = selectedTask {
            lblTaskTitile.text = task.taskName
            if let taskDescription = task.taskDescription {
                taskDescriptionTextView.textColor = textViewDefaultTextColot
                taskDescriptionTextView.text = taskDescription
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        if navigationTitle == "Edit task" {
//            let index = taskListController.tasksTableView.indexPathForSelectedRow?.row
//            taskListController.taskList?[index!].taskDescription = taskDescriptionTextView.text
//            taskListController.taskList?[index!].taskName = lblTaskTitile.text
//            taskListController.taskList?[index!].taskDate = Date.init()
//        }
        
    }
    
    func done() {
//        performSegue(withIdentifier: "backToTaskList", sender: self)
//        if let taskIndex = selectedTaskIndex {
        if let task = selectedTask {
//            taskListController.taskList?[taskIndex].taskDescription = taskDescriptionTextView.text
//            taskListController.taskList?[taskIndex].taskName = lblTaskTitile.text
//            taskListController.taskList?[taskIndex].taskDate = Date.init()
            task.taskDescription = taskDescriptionTextView.text
            task.taskName = lblTaskTitile.text
//            task.date = Date.init()
        }
        else {
//            let task = DailyTask(withDescription: taskDescriptionTextView.text,
//                                 andName: lblTaskTitile.text,
//                                 andDate: Date.init())
//            taskListController.taskList.append(task)
            let task = NSEntityDescription.insertNewObject(forEntityName: "Task",
                                                           into: dataController.managedObjectContext) as! DailyTaskMO
            task.taskName = lblTaskTitile.text
            task.taskDescription = taskDescriptionTextView.text
//            task.date = Date.init()
            task.date = datePicker.date
            
//            task.setValue(lblTaskTitile.text, forKey: "taskName")
//            task.setValue(taskDescriptionTextView.text, forKey: "taskDescription")
//            task.setValue(Date.init(), forKey: "date")
        }
        
//        do {
//            try dataController.managedObjectContext.save()
//        } catch {
//            fatalError("Failure to save context: \(error)")
//        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if taskDescriptionTextView.text == placeholderString {
            taskDescriptionTextView.text = ""
            taskDescriptionTextView.textColor = textViewDefaultTextColot
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if taskDescriptionTextView.text == "" {
            taskDescriptionTextView.text = placeholderString
            taskDescriptionTextView.textColor = textViewPlaceholderTextColor
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
