//
//  DailyTaskMO.swift
//  ios-daily-tasks
//
//  Created by Николай on 05.02.17.
//  Copyright © 2017 Николай. All rights reserved.
//

import UIKit
import CoreData

class DailyTaskMO: NSManagedObject {
    
    @NSManaged var taskName: String?
    @NSManaged var taskDescription: String?
    @NSManaged var date: Date
    @NSManaged var checked: Bool
}
