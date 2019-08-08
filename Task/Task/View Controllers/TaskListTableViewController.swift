//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Cameron Stuart on 8/7/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.sharedInstance.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        
        let task = TaskController.sharedInstance.tasks[indexPath.row]

        cell.primaryLabel.text = task.name
        cell.task = task
        cell.delegate = self
        
        return cell
    }
    
    func updateButton(cell: ButtonTableViewCell) {
        guard let task = cell.task else { return }
        TaskController.sharedInstance.toggleIsCompleteFor(task: task)
        if task.isComplete == true {
            cell.completeButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            cell.completeButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = TaskController.sharedInstance.tasks[indexPath.row]
            TaskController.sharedInstance.remove(task: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.reloadData()
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
            let task = TaskController.sharedInstance.tasks[indexPath.row]
            destinationVC.task = task
        }
    }
}

extension TaskListTableViewController: TaskTableViewCellDelegate {
    func completedButtonChangedStatus(cell: ButtonTableViewCell) {
        updateButton(cell: cell)
    }
}
