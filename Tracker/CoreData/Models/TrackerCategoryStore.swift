//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.05.2024.
//

import CoreData

final class TrackerCategoryStore {
    
    static let shared = TrackerCategoryStore()
    private let coreDataManager = CoreDataManager.shared
    private let trackerStore = TrackerStore.shared
    private init(){}
    
    var category: [TrackerCategory] {
        guard let objects = try? self.fetchCategory() else {
            return []
        }
        let category = objects.compactMap({ self.category(category: $0) })
        return category
    }
    
    func addCategory(category: TrackerCategory) throws {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", category.title)
        
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            if results.isEmpty {
                let categoryEntity = TrackerCategoryCoreData(context: coreDataManager.context)
                categoryEntity.title = category.title
            }
            coreDataManager.saveContext()
        }
        catch let error as NSError {
            print("Ошибка добавления новой категории. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func fetchCategory() throws -> [TrackerCategoryCoreData]{
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        var categoryList = [TrackerCategoryCoreData]()
        do {
            categoryList = try coreDataManager.context.fetch(request)
            
        } catch let error as NSError {
            print("Ошибка извлечения категорий. \(error), \(error.userInfo)")
            throw error
        }
        return categoryList
    }
    
    func category(category: TrackerCategoryCoreData) -> TrackerCategory?{
        guard let title = category.title,
              let trackers = category.trackers
        else {return nil}
        return TrackerCategory(title: title, trackers: trackers.compactMap {
            trackerCoreData -> Tracker? in
            if let trackerCoreData = trackerCoreData as? TrackerCoreData {
                return try? trackerStore.tracker(tracker: trackerCoreData)
            }
            return nil
        })
    }
    
    func deleteCategory(category: TrackerCategory) throws{
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", category.title)
        
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            if let objectToDelete = results.first {
                coreDataManager.context.delete(objectToDelete)
            }
            coreDataManager.saveContext()
        }
        catch let error as NSError {
            print("Ошибка удаления категории. \(error), \(error.userInfo)")
            throw error
        }
    }
}

