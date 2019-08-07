//
//  Task+Convenience.swift
//  Task
//
//  Created by Cameron Stuart on 8/7/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    @discardableResult convenience init(name: String, notes: String = "", due: Date = Date(), isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = isComplete
    }
}
