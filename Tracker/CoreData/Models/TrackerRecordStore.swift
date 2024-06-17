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
    
    func addRecord(trackerRecord: TrackerRecord){
        let recordEntity = TrackerRecordCoreData(context: coreDataManager.context)
        recordEntity.date = trackerRecord.date
        recordEntity.trackerId = trackerRecord.trackerId
        coreDataManager.saveContext()
    }
    
    func fetchTrackerRecords() -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let trackerRecordsEntities = try coreDataManager.context.fetch(fetchRequest)
            let trackerRecords = trackerRecordsEntities.compactMap { recordEntity ->
                TrackerRecord? in
                guard let trackerId = recordEntity.trackerId,
                      let date = recordEntity.date else {return nil}
                return TrackerRecord(trackerId: trackerId, date: date)
            }
            return trackerRecords
        } catch let error as NSError {
            print("Ошибка извлечения выполненных трекеров: \(error), \(error.userInfo)")
            return []
        }
    }
    
    func deleteTrackerRecord(with id: UUID, date: Date) throws {
            let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", id as CVarArg, date as CVarArg)
            
            do {
                let results = try coreDataManager.context.fetch(fetchRequest)
                for object in results {
                    coreDataManager.context.delete(object)
                }
                coreDataManager.saveContext()
            } catch let error as NSError {
                print("Ошибка удаления записи трекера: \(error), \(error.userInfo)")
                throw error
            }
        }
}
