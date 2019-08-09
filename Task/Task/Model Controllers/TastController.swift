//
//  TastController.swift
//  Task
//
//  Created by Cameron Stuart on 8/7/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    static let sharedInstance = TaskController()
    var fetchedResultsController: NSFetchedResultsController<Task>

    init () {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: false), NSSortDescriptor(key: "due", ascending: true)]
        
        let resultsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "Complete", cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch!!!")
        }
    }
    
    var predicate: NSPredicate?
    
    //MARK: - CRUD
    
    // Create
    func add(taskWithName name: String, notes: String?, due: Date?) {
        if let notes = notes, let due = due {
            _ = Task(name: name, notes: notes, due: due)
        } else {
             Task(name: name)
        }
        print("Called: add function")
        saveToPersistentStore()
    }
    
    // Update
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStore()
    }
    
    func toggleIsCompleteFor(task: Task) {
        task.isComplete.toggle()
        saveToPersistentStore()
    }
    
    // Delete
    func remove(task: Task) {
        CoreDataStack.context.delete(task)
        saveToPersistentStore()
    }
    
    // Save
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving to persistent store in Function: \(#function): \(error.localizedDescription)")
        }
    }
    
//    // Fetch
//    func fetchTasks() -> [Task] {
//        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        fetchRequest.predicate = predicate
//        do {
//            let fetchedTasks = try CoreDataStack.context.fetch(fetchRequest)
//            return fetchedTasks
//        } catch {
//            print("Error")
//            return []
//        }
//    }
}
