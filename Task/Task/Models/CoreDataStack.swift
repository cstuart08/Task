//
//  CoreDataStack.swift
//  Task
//
//  Created by Cameron Stuart on 8/7/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // Sets the Persistent Container and makes it accessable to the rest of the project.
    // NSPersistent container will manage MOC, PSC, & PS.
    static var container: NSPersistentContainer = {
        
        // sets the specific container to an identifier.
        let container = NSPersistentContainer(name: "Task")
        // Once container exists, loadPersistentStores will complete the creation of the container.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            // sets app to crash incase error exists in loadPersistentStores
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // Project wide variable to connect to the MOC.
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
