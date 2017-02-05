//
//  ViewController.swift
//  ios-daily-tasks
//
//  Created by Николай on 03.02.17.
//  Copyright © 2017 Николай. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    NSFetchedResultsControllerDelegate, TaskTableViewCellProtocol {

    @IBOutlet weak var tasksTableView: UITableView!
    var btnDone: UIBarButtonItem!
    var btnRemove: UIBarButtonItem!
    var btnAdd: UIBarButtonItem!
    var btnHistory: UIBarButtonItem!
    @IBOutlet weak var taskListBar: UINavigationItem!
    
//    var taskList : [DailyTask]!
    
    var currentDate: Date!
    var shouldUpdateFetchController: Bool = false
    
    weak var appDelegate: AppDelegate!
    weak var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<DailyTaskMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentDate = Date.init()
        
        btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(TaskListViewController.done));
        btnAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(TaskListViewController.add))
        btnRemove = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(TaskListViewController.remove))
        btnHistory = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(TaskListViewController.history))
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
//        taskList = ["Go shopping", "Write program"]
//        taskList = []
        
        taskListBar.rightBarButtonItems = [btnAdd, btnRemove]
        taskListBar.leftBarButtonItems = [btnHistory]
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        let today = Calendar.current.date(from: dateComponents)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today!)
        let predicate = NSPredicate(format: "date > %@ and date < %@", argumentArray: [today!, tomorrow!])
        
        let request = NSFetchRequest<DailyTaskMO>(entityName: "Task")
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: dataController.managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tasksTableView.reloadData()
        if shouldUpdateFetchController {
//            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
//            let predicate = NSPredicate(format: "date > %@", argumentArray: [Calendar.current.date(from: dateComponents)!])
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
            let today = Calendar.current.date(from: dateComponents)
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today!)
            let predicate = NSPredicate(format: "date > %@ AND date < %@", argumentArray: [today!, tomorrow!])
            fetchedResultsController.fetchRequest.predicate = predicate
            do {
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("Failed to initialize FetchedResultsController: \(error)")
            }
            tasksTableView.reloadData()
            
            shouldUpdateFetchController = false
        }
        
//        let dateComponents = Calendar.current.dateComponents(<#T##components: Set<Calendar.Component>##Set<Calendar.Component>#>, from: <#T##Date#>)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy";
        taskListBar.title = formatter.string(from: currentDate)
    }

    func done() {
        taskListBar.rightBarButtonItems = [btnAdd, btnRemove]
        tasksTableView.setEditing(false, animated: true)
    }
    
    func add() {
        performSegue(withIdentifier: "addTaskSegue", sender: self)
    }
    
    func remove() {
        taskListBar.rightBarButtonItems = [btnDone]
        tasksTableView.setEditing(true, animated: true)
    }
    
    func history() {
        performSegue(withIdentifier: "showDatePicker", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskSegue" {
            if let destController = segue.destination as? AddTaskViewController {
                destController.navigationTitle = "Edit task"
//                destController.taskListController = self
//                destController.selectedTaskIndex = tasksTableView.indexPathForSelectedRow?.row
                destController.dataController = dataController
                
                let indexPath = tasksTableView.indexPathForSelectedRow!
                let selectedObject = fetchedResultsController.object(at: indexPath) 
                destController.selectedTask = selectedObject
            }
        }
        else if segue.identifier == "addTaskSegue" {
            if let destController = segue.destination as? AddTaskViewController {
                destController.navigationTitle = "Add task"
//                destController.taskListController = self
                destController.dataController = dataController
            }
        }
        else if segue.identifier == "showDatePicker" {
            if let destController = segue.destination as? DatePickerViewController {
                destController.taskListViewController = self
            }
        }
    }

    func configureCell(cell: TaskCellTableViewCell, indexPath: IndexPath) {
        guard let selectedObject = fetchedResultsController.object(at: indexPath) as DailyTaskMO? else {
            fatalError("Could not get selected object")
        }

        cell.taskText.text = selectedObject.taskName
        cell.btnCheckTask.isSelected = selectedObject.checked
        cell.task = selectedObject
    }
    
    // MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
        print("Number of sections \(fetchedResultsController.sections!.count)")
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return taskList.count
//        let sectionInfo = fetchedResultsController
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        print("Number of rows \(sections[section].numberOfObjects) in section \(section)")
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tasksTableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCellTableViewCell
//        let task = taskList[indexPath.row]
        
//        guard let selectedObject = fetchedResultsController.object(at: indexPath) as DailyTaskMO? else {
//            fatalError("Could not get selected object")
//        }
//        
////        cell.taskText.text = task.taskName
////        cell.btnCheckTask.isSelected = task.checked
////        cell.task = task
//        cell.taskText.text = selectedObject.taskName
//        cell.btnCheckTask.isSelected = selectedObject.checked
////        cell.task = selectedObject
//        
        configureCell(cell: cell, indexPath: indexPath)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let object = fetchedResultsController.object(at: indexPath)
        dataController.managedObjectContext.delete(object)
//        fetchedResultsController
//        taskList.remove(at: index)
//        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    // MARK: - Fetched Results Controller Delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            tasksTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tasksTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
//            configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
            let cell = tasksTableView.cellForRow(at: indexPath!) as! TaskCellTableViewCell
            configureCell(cell: cell, indexPath: indexPath!)
        default:
            print("Nothing to do")
        }
    }
    
    // MARK: - TaskTabkeViewCellProtocol
    func taskChecked(sender: TaskCellTableViewCell?) {
//        do {
//            try dataController.managedObjectContext.save()
//        } catch {
//            fatalError("Failure to save context: \(error)")
//        }
    }
}

