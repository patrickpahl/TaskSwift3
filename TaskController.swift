//
//  EntryController.swift
//  TaskSwift3
//
//  Created by Patrick Pahl on 10/15/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

class TaskController {
    
    static let sharedController = TaskController()
    
    var fetchedResultsController: NSFetchedResultsController<Task>
    
    init(){
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let isCompleteSortDescriptor = NSSortDescriptor(key: "isComplete", ascending: true)
        let dueSortDescriptor = NSSortDescriptor(key: "due", ascending: true)
        request.sortDescriptors = [isCompleteSortDescriptor, dueSortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Error peforming fetch: \(error)")
        }
    }
    
    func createTask(title: String, notes: String?, due: Date?, isComplete: Bool?) -> Task {
        
        let task = Task(title: title, notes: nil, isComplete: nil, due: nil, context: CoreDataStack.context)
        if let notes = notes { task.notes = notes}
        if let due = due {task.due = due as NSDate}
        if let isComplete = isComplete {task.isComplete = isComplete}
        
        scheduleNotification(task: task)
        return task
    }
    
    func update(task: Task, title: String?, notes: String?, due: Date?) {
        if let title = title {task.title = title}
        if let notes = notes {task.notes = notes}
        if let due = due {
            task.due = due as NSDate
            cancelNotification(task: task)
            scheduleNotification(task: task)
        }
    }
    
    func updateCompleteToggle(task: Task){
        task.isComplete = !task.isComplete
        if task.isComplete {
            cancelNotification(task: task)
        } else {
            scheduleNotification(task: task)
        }
    }
    
    func remove(task: Task) {
        task.managedObjectContext?.delete(task)
        cancelNotification(task:task)
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            NSLog("Error while saving CoreData: \(error.localizedDescription)")
        }
    }
    
    
    func scheduleNotification(task: Task) {
    //Create notificiation content
    //Create a trigger and identifier
    //Create notification request
    //Add request to the app
        
        guard let title = task.title, let date = task.due as? Date else {return}
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        if let notes = task.notes {
            notificationContent.body = String(notes.characters.prefix(20))
            //prefix: max length of characters 20
        }
        
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        guard let idUnwrapped = task.id else {return}
        
        let request = UNNotificationRequest(identifier: idUnwrapped, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func cancelNotification(task: Task) {
        guard let idUnwrapped = task.id else {return}
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [idUnwrapped])
    }
    
}



