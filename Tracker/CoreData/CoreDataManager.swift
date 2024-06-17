//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Андрей Тапалов on 08.05.2024.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init(){}
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                
            }
        }
        return container
    }()
    
    func saveContext(){
        
        if context.hasChanges {
            do {
                try context.save()}
            catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
