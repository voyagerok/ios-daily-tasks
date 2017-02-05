//
//  DatePickerViewController.swift
//  ios-daily-tasks
//
//  Created by Николай on 05.02.17.
//  Copyright © 2017 Николай. All rights reserved.
//

import UIKit
import FSCalendar

class DatePickerViewController: UIViewController {

    weak var taskListViewController: TaskListViewController!
    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
//        print("Selected date is \(calendarView.selectedDate)")
        if calendarView.selectedDates.count > 0 {
            taskListViewController.currentDate = calendarView.selectedDate
            taskListViewController.shouldUpdateFetchController = true
        }
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
