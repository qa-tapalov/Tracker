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
    
    private init(){}
    
    func addCategory(category: String) throws{
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", category)
        
        do {
            let results = try coreDataManager.context.fetch(fetchRequest)
            if results.isEmpty {
                let categoryEntity = TrackerCategoryCoreData(context: coreDataManager.context)
                categoryEntity.title = category
            }
            coreDataManager.saveContext()
        }
        catch let error as NSError {
            print("Ошибка добавления новой категории. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func fetchCategory() throws{
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            let categoryList = try coreDataManager.context.fetch(request)
            print(categoryList)
        } catch let error as NSError {
            print("Ошибка извлечения категорий. \(error), \(error.userInfo)")
            throw error
        }
        
    }
}

