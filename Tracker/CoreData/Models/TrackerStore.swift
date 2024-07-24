//
//  TrackerStore.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.05.2024.
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func update()
}

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    private let coreDataManager = CoreDataManager.shared
    weak var delegate: TrackerStoreDelegate?
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: coreDataManager.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    var trackers: [Tracker] {
        guard let objects = self.fetchedResultsController.fetchedObjects
        else { return [] }
        let trackers = try! objects.compactMap({ try self.tracker(tracker: $0) })
        return trackers
    }
    
    private override init(){}
    
    func addTracker(tracker: Tracker, categoryTitle: String) throws{
        let trackerCategory: TrackerCategoryCoreData!
        let trackerCoreData: TrackerCoreData!
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        let fetchRequestTracker: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequestTracker.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            trackerCategory = results.first
            
            let fetchTracker = try! coreDataManager.context.fetch(fetchRequestTracker)
            trackerCoreData = fetchTracker.first
            if !fetchTracker.isEmpty {
                trackerCoreData.id = tracker.id
                trackerCoreData.name = tracker.name
                trackerCoreData.color = tracker.color
                trackerCoreData.emogi = tracker.emogi
                trackerCoreData.schedule = tracker.schedule as [NSNumber] as NSObject
                trackerCoreData.category = trackerCategory
            } else {
                let trackerEntity = TrackerCoreData(context: coreDataManager.context)
                trackerEntity.id = tracker.id
                trackerEntity.name = tracker.name
                trackerEntity.color = tracker.color
                trackerEntity.emogi = tracker.emogi
                trackerEntity.schedule = tracker.schedule as [NSNumber] as NSObject
                trackerEntity.category = trackerCategory
            }
            coreDataManager.saveContext()
        }
        catch let error as NSError {
            print("Ошибка добавления нового трекера. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func deleteTracker(with id: UUID) throws {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            for object in results {
                coreDataManager.context.delete(object)
            }
            coreDataManager.saveContext()
        } catch let error as NSError {
            print("Ошибка удаления трекера: \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func tracker(tracker: TrackerCoreData) throws-> Tracker? {
        guard let id = tracker.id,
              let name = tracker.name,
              let color = tracker.color,
              let emogi = tracker.emogi,
              let schedule = tracker.schedule as? [Int] else {return nil}
        return Tracker(id: id, name: name, color: color as! UIColor, emogi: emogi, schedule: schedule )
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.update()
    }
}
