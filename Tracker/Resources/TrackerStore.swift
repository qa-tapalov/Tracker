//
//  TrackerStore.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.05.2024.
//

import Foundation
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
}
