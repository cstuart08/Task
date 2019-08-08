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
    
    var tasks: [Task] {
        return fetchTasks()
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
    
    // Fetch
    func fetchTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let fetchedTasks = try CoreDataStack.context.fetch(fetchRequest)
            return fetchedTasks
        } catch {
            print("Error")
            return []
        }
    }
}
