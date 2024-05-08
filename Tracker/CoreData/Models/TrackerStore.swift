//
//  TrackerStore.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.05.2024.
//

import CoreData

final class TrackerStore {
    
    static let shared = TrackerStore()
    private let coreDataManager = CoreDataManager.shared
    
    private init(){}
    
    func addTracker(tracker: Tracker, categoryTitle: String) throws{
        let trackerCategory: TrackerCategoryCoreData!
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            trackerCategory = results.first
            
            let trackerEntity = TrackerCoreData(context: coreDataManager.context)
            trackerEntity.id = tracker.id
            trackerEntity.name = tracker.name
            trackerEntity.color = tracker.color
            trackerEntity.emogi = tracker.emogi
            trackerEntity.schedule = tracker.shedule as NSObject
            trackerEntity.category = trackerCategory
            
            coreDataManager.saveContext()
        }
        catch let error as NSError {
            print("❌❌❌ Ошибка добавления нового трекера. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    //    func fetchTrackers() throws {
    //        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
    //        
    //        do {
    //            let trackers = try coreDataManager.context.fetch(request)
    //            for tracker in trackers {
    //                if let category = tracker.category?.title
    //            }
    //        }
    //    }
    
}
