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
    
    func addCategory(category: String){
        let categoryEntity = TrackerCategoryCoreData(context: coreDataManager.context)
        categoryEntity.title = category
        coreDataManager.saveContext()
    }
}
