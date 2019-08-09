//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Cameron Stuart on 8/7/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    var task: Task?
    var dueDateValue: Date?
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDueDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        taskNameTextField.delegate = self
        taskDueDateTextField.delegate = self
        self.tableView.addGestureRecognizer(tapGesture)
        taskDueDateTextField.inputView = dueDatePicker
        updateViews()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = taskNameTextField.text, let notes = notesTextView.text else { return }
        if let saveTask = task {
            TaskController.sharedInstance.update(task: saveTask, name: name, notes: notes, due: dueDatePicker.date)
        } else {
            TaskController.sharedInstance.add(taskWithName: name, notes: notes, due: dueDatePicker.date)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateValue = dueDatePicker.date
        taskDueDateTextField.text = dueDateValue?.stringValue()
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        taskNameTextField.resignFirstResponder()
        taskDueDateTextField.resignFirstResponder()
        notesTextView.resignFirstResponder()
        dueDatePicker.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    func updateViews() {
        guard let task = task else { return }
        taskNameTextField.text = task.name
        notesTextView.text = task.notes
        taskDueDateTextField.text = task.due?.stringValue()
        guard let dueDate = task.due else { return }
        dueDatePicker.date = dueDate
    }
}
