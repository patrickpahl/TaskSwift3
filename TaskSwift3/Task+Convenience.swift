//
//  Entry+Convenience.swift
//  TaskSwift3
//
//  Created by Patrick Pahl on 10/16/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation
import CoreData

//In Swift3, Entity classes are created behind the scenes.

extension Task {
    
    convenience init(title: String, notes: String?, isComplete: Bool?, due: Date?, context: NSManagedObjectContext) {
        
        self.init(context: context)
        //Bc we have a conv init, we need this designated initializer.
        
        self.title = title
        self.notes = notes
        self.due = due as NSDate?
        //Need to cast due as NSDate now
        self.id = String(describing: UUID())
        if let isComplete = isComplete {
            self.isComplete = isComplete
        } else {
            self.isComplete = false
        }
    }
}


//isComplete bool is not optional, but must be declared so here.
//If you had a timestamp, timestamp: Date = Date()
