//
//  DailyTask.swift
//  ios-daily-tasks
//
//  Created by Николай on 04.02.17.
//  Copyright © 2017 Николай. All rights reserved.
//

import UIKit

class DailyTask: NSObject {
    
    var taskDescription: String!
    var taskName: String!
    var taskDate: Date!
    var checked: Bool
    
    init(withDescription aDescription: String!,
         andName aName: String!,
         andDate aDate: Date!)
    {
        taskDescription = aDescription
        taskName = aName
        taskDate = aDate
        checked = false
    }

}
