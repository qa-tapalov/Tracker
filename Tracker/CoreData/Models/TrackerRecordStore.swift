//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.05.2024.
//

import CoreData

final class TrackerRecordStore {
    
    static let shared = TrackerRecordStore()
    private let coreDataManager = CoreDataManager.shared
    
    private init(){}
    
    func addRecord(date: Date, trackerId: UUID){
        let recordEntity = TrackerRecordCoreData(context: coreDataManager.context)
        recordEntity.date = date
        recordEntity.trackerId = trackerId
        coreDataManager.saveContext()
    }
}
