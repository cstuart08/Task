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
    
    var sharedInstance = TaskController()
    
    var tasks = [Task]()
    
    init() {
        tasks = fetchTasks()
    }
    
    let mockTasks: [Task] = [
        Task(name: "Garbage", notes: "Take out Garbage", due: Date()),
        Task(name: "Clean", notes: "Clean the house", due: Date()),
        Task(name: "Workout", notes: "Go to the gym", due: Date(), isComplete: true)
    ]
    
    
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
        do {
            let fetchedTasks = try CoreDataStack.context.fetch(fetchRequest)
            return mockTasks
        } catch {
            print("Error")
            return []
        }
    }
}
