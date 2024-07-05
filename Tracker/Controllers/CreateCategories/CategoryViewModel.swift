//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Андрей Тапалов on 25.06.2024.
//

import Foundation

protocol CategoryViewModelProtocol: AnyObject {
    var cellCategoryDataSource: Observable<[TrackerCategory]> { get set }
    func addCategory(category: TrackerCategory) throws
    func numbersOfRows() -> Int
    func fetchCategory()
}

final class CategoryViewModel: CategoryViewModelProtocol {
    
    private let categoryStore = TrackerCategoryStore.shared
    var cellCategoryDataSource: Observable<[TrackerCategory]> = Observable(value: nil)
    private var categoryDataSource: [TrackerCategory] = []
    
    func addCategory(category: TrackerCategory) throws {
        try categoryStore.addCategory(category: category.title)
        fetchCategory()
    }
    
    func numbersOfRows() -> Int{
        return categoryDataSource.count
    }
    
    func fetchCategory(){
        categoryDataSource = categoryStore.category
        cellCategoryDataSource.value = categoryDataSource
    }
}
