//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Cameron Stuart on 8/7/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, UISearchBarDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate
        TaskController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionNames = TaskController.sharedInstance.fetchedResultsController.sections?[section] else { return "" }
        if sectionNames.name == "0" {
            return "Incomplete"
        } else {
            return "Complete"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        
        
        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.primaryLabel.text = task.name
        cell.task = task
        cell.delegate = self
        
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let task = TaskController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
            TaskController.sharedInstance.remove(task: task)
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            TaskController.sharedInstance.predicate = nil
            tableView.reloadData()
            return
        }
        let namePredicate = NSPredicate(format: "name contains[cd] %@", argumentArray: [searchText])
        let notesPredicate = NSPredicate(format: "notes contains[cd] %@", argumentArray: [searchText])
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, notesPredicate])
        TaskController.sharedInstance.predicate = predicate
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskToDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TaskDetailTableViewController else { return }
            
            let task = TaskController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row]
            destinationVC.task = task
        }
    }
}

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: return
        }
    }
    
}
extension TaskListTableViewController: TaskTableViewCellDelegate {
    func completedButtonChangedStatus(_ sender: ButtonTableViewCell) {
        guard let task = sender.task else { return }
        TaskController.sharedInstance.toggleIsCompleteFor(task: task)
        sender.updateViews()
    }
}
