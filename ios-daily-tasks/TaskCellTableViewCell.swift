//
//  TaskCellTableViewCell.swift
//  ios-daily-tasks
//
//  Created by Николай on 03.02.17.
//  Copyright © 2017 Николай. All rights reserved.
//

import UIKit

protocol TaskTableViewCellProtocol {
    func taskChecked(sender: TaskCellTableViewCell?)
}

class TaskCellTableViewCell: UITableViewCell {

    @IBOutlet weak var taskText: UILabel!
    @IBOutlet weak var btnCheckTask: CheckTaskButton!
    
    weak var task: DailyTaskMO!
    var delegate: TaskTableViewCellProtocol?
    
    var taskChecked : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        taskText.text = task.taskName
//        btnCheckTask.isSelected = task.checked
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func checkTask(_ sender: Any) {
        taskChecked = !taskChecked
        btnCheckTask.isSelected = taskChecked
        task.checked = taskChecked
        if (delegate != nil) {
            delegate?.taskChecked(sender: self)
        }
    }
}
