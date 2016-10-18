//
//  DetailViewController.swift
//  TaskSwift3
//
//  Created by Patrick Pahl on 10/15/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWith()
    }
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var taskTextView: UITextView!
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        
        if let taskName = taskTextField.text, taskName != "" {
            if let task = task {
                TaskController.sharedController.update(task: task, title: taskName, notes: taskTextView.text, due: dueDatePicker.date)
            } else {
                let _ = TaskController.sharedController.createTask(title: taskName, notes: taskTextView.text, due: dueDatePicker.date, isComplete: false)
            }
            let _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func userTappedView(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    func updateWith() {
        guard let task = task else {return}
        taskTextField.text = task.title
        taskTextView.text = task.notes
        if let due = task.due {
            dueDatePicker.date = due as Date
        }
    }
}
