//
//  ViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.04.2024.
//

import UIKit

protocol AddTrackerDelegate: AnyObject {
    func didAddTracker(_ tracker: Tracker, title: String)
}

protocol SelectFilterDelegate: AnyObject {
    func didSelectedFilter(filter: Filters)
}

final class TrackerViewController: UIViewController {
    
    var filteredCategories: [TrackerCategory] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private let trackerStore = TrackerStore.shared
    private let recordsStore = TrackerRecordStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    private let analyticService = AnalyticService()
    private var selectedFilter = "Все трекеры"
    private var savedCategories: [UUID: String] = [:]
    
    private lazy var labelEmptyList: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString("emptyListTrackers", comment: "Title for empty trackers")
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stubImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .stubEmptyList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .compact
        view.locale = Locale(identifier: "ru_Ru")
        view.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        view.date = Calendar.current.startOfDay(for: Date())
        view.maximumDate = Date()
        return view
    }()
    
    private let stubImageFilter: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .errorFilter)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stubLabelFilter: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString("stubLabelFilter", comment: "Title for empty filter")
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let view = UISearchTextField()
        view.placeholder = "Поиск"
        view.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return view
    }()
    
    private lazy var buttonFilter: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.blue
        view.layer.cornerRadius = 16
        view.setTitle(NSLocalizedString("FiltersTitle", comment: "Title for filter button"), for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.setTitleColor(UIColor(resource: .white), for: .normal)
        view.addTarget(self, action: #selector(actionFilter), for: .touchUpInside)
        return view
    }()
    
    weak var delegate: TrackerStoreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("TrackersTitle", comment: "Title for trackers tab")
        setupView()
        trackerStore.delegate = self
        fetchData()
        configureNavBar()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticService.report(event: "open", params: ["screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        analyticService.report(event: "close", params: ["screen": "Main"])
    }
    
    private func fetchData(){
        categories = categoryStore.category
        if let index = categories.firstIndex(where: {$0.title == "Закрепленные"}){
            let category = categories.remove(at: index)
            categories.insert(category, at: 0)
        }
        completedTrackers = recordsStore.fetchTrackerRecords()
        dateValueChanged()
    }
    
    private func configureNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(addTracker))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.navigationBar.tintColor = UIColor(resource: .black)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView(){
        view.backgroundColor = UIColor(resource: .white)
        view.addSubview(stubImage)
        view.addSubview(labelEmptyList)
        view.addSubview(collectionView)
        view.addSubview(searchTextField)
        view.addSubview(buttonFilter)
        view.addSubview(stubImageFilter)
        view.addSubview(stubLabelFilter)
        setupCollection()
        setupConstraitsStubImage()
        setupConstraitsLabelEmptyList()
        setupConstraitsSearchBar()
        setupConstraitsButtonFilter()
        collectionView.register(TrackerViewCollectionCell.self, forCellWithReuseIdentifier: TrackerViewCollectionCell.reuseIdentifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.supplementaryIdentifier)
    }
    
    private func setupCollection(){
        collectionView.backgroundColor = UIColor(resource: .white)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupConstraitsStubImage(){
        NSLayoutConstraint.activate([
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            stubImageFilter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageFilter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubImageFilter.widthAnchor.constraint(equalToConstant: 80),
            stubImageFilter.heightAnchor.constraint(equalToConstant: 80)
        ])
        
    }
    
    private func setupConstraitsLabelEmptyList(){
        NSLayoutConstraint.activate([
            labelEmptyList.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            labelEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stubLabelFilter.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabelFilter.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupConstraitsSearchBar(){
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupConstraitsButtonFilter(){
        NSLayoutConstraint.activate([
            buttonFilter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonFilter.widthAnchor.constraint(equalToConstant: 114),
            buttonFilter.heightAnchor.constraint(equalToConstant: 50),
            buttonFilter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func dateValueChanged(){
        filterTrackers()
        presentedViewController?.dismiss(animated: false)
    }
    
    @objc private func addTracker(){
        analyticService.report(event: "click", params: ["screen": "Main", "item": "add_track"])
        let vc = CreateTrackerViewController()
        vc.modalPresentationStyle = .formSheet
        vc.delegateAddTracker = self
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func actionFilter(){
        analyticService.report(event: "click", params: ["screen": "Main", "item": "filter"])
        let vc = FiltersViewController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        vc.selectedFilter = selectedFilter
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc func textFieldChanged() {
        guard let text = searchTextField.text else {return}
        if text.count >= 3 || text.isEmpty {
            filterTrackers()
        }
    }
    
    private func filterTrackers(){
        let selectedDate = datePicker.date
        let filterWeekday = Calendar.current.component(.weekday, from: selectedDate)
        let filterText = searchTextField.text?.lowercased() ?? ""
        
        switch selectedFilter {
        case "Завершенные":
            filteredCategories = categories.map { category in
                let completedTrackers = category.trackers.filter { tracker in
                    return isTrackerCompletedToday(id: tracker.id) &&  (tracker.name.lowercased().contains(filterText) || filterText.isEmpty)
                }
                return TrackerCategory(title: category.title, trackers: completedTrackers)
            }.filter {!$0.trackers.isEmpty}
        case "Не завершенные":
            filteredCategories = categories.map { category in
                let completedTrackers = category.trackers.filter { tracker in
                    return (!isTrackerCompletedToday(id: tracker.id) && (isTrackerScheduledForToday(tracker: tracker) || tracker.schedule.isEmpty)) && (tracker.name.lowercased().contains(filterText) || filterText.isEmpty)
                }
                return TrackerCategory(title: category.title, trackers: completedTrackers)
            }.filter {!$0.trackers.isEmpty}
            
        default:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty ||
                    tracker.name.lowercased().contains(filterText)
                    
                    let dateCondition = tracker.schedule.contains { weekDay in
                        weekDay == filterWeekday
                    } || tracker.schedule.isEmpty
                    
                    return textCondition && dateCondition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title,
                                       trackers: trackers)
            }
        }
        updateView()
    }
    
    func updateView(){
        let isCategoriesEmpty = categories.isEmpty
        let isFilteredCategoriesEmpty = filteredCategories.isEmpty
        let isSearchTextEmpty = searchTextField.text?.isEmpty ?? true
        
        let showEmptyState = isCategoriesEmpty || (isFilteredCategoriesEmpty && isSearchTextEmpty)
        let showFilterEmptyState = isFilteredCategoriesEmpty && !isSearchTextEmpty
        
        collectionView.isHidden = showEmptyState || showFilterEmptyState
        buttonFilter.isHidden = showEmptyState || showFilterEmptyState
        stubImage.isHidden = !showEmptyState
        labelEmptyList.isHidden = !showEmptyState
        stubImageFilter.isHidden = !showFilterEmptyState
        stubLabelFilter.isHidden = !showFilterEmptyState
        
        collectionView.reloadData()
    }
    
    func editTracker(at indexPath: IndexPath) {
        let vc = CreateNewTrackerViewController()
        vc.delegateAddTracker = self
        let tracker = self.filteredCategories[indexPath.section].trackers[indexPath.row]
        vc.selectedCategory = self.filteredCategories[indexPath.section].title
        if tracker.schedule.isEmpty {
            vc.typeTracker = "Event"
        }
        let completedDays = completedTrackers.filter {$0.trackerId == tracker.id}.count
        vc.daysCount = completedDays
        vc.isEditTracker = true
        vc.createTracker(tracker: tracker)
        vc.modalPresentationStyle = .formSheet
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func isTrackerPinned(tracker: Tracker) -> Bool {
        filteredCategories.contains {category in
            category.title == "Закрепленные" && category.trackers.contains {trackerId in
                trackerId.id == tracker.id}}
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == id && isSameDay
        }
    }
    
    private func isTrackerScheduledForToday(tracker: Tracker) -> Bool {
        let selectedDate = datePicker.date
        let filterWeekday = Calendar.current.component(.weekday, from: selectedDate)
        return tracker.schedule.contains(filterWeekday)
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Уверены, что хотите удалить трекер?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else {return}
            let trackerId = filteredCategories[indexPath.section].trackers[indexPath.row].id
            try? self.trackerStore.deleteTracker(with: trackerId)
            fetchData()
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func pinTracker(indexPath: IndexPath){
        try? categoryStore.addCategory(category: TrackerCategory(title: "Закрепленные", trackers: []))
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let category = filteredCategories[indexPath.section].title
        savedCategories[tracker.id] = category
        try? trackerStore.deleteTracker(with: tracker.id)
        try? trackerStore.addTracker(tracker: tracker, categoryTitle: "Закрепленные")
        fetchData()
    }
    
    private func unpinTracker(indexPath: IndexPath){
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        if let category = savedCategories[tracker.id] {
            try? trackerStore.deleteTracker(with: tracker.id)
            try? trackerStore.addTracker(tracker: tracker, categoryTitle: category)
        }
        savedCategories.removeValue(forKey: tracker.id)
        fetchData()
    }
    
}

extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCollectionCell.reuseIdentifier, for: indexPath) as? TrackerViewCollectionCell else { return UICollectionViewCell() }
        cell.prepareForReuse()
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let isPinned = isTrackerPinned(tracker: tracker)
        let completedDays = completedTrackers.filter {$0.trackerId == tracker.id}.count
        cell.configure(tracker: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, isPinned: isPinned, indexPath: indexPath)
        
        return cell
    }
    
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRow = 2
        let leftInset = 16
        let rightInset = 16
        let cellSpacing = 10
        let paddingWidth: CGFloat = CGFloat(leftInset + rightInset + (cellsPerRow - 1) * cellSpacing)
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth =  availableWidth / CGFloat(cellsPerRow)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.supplementaryIdentifier, for: indexPath) as! SupplementaryView
        header.title.text = filteredCategories[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let isPinned = isTrackerPinned(tracker: tracker)
        return UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            guard let self else {return nil}
            
            return UIMenu(children: [
                UIAction(title: isPinned ? "Открепить" : "Закрепить",
                         handler: { _ in
                             isPinned ? self.unpinTracker(indexPath: indexPath) :   self.pinTracker(indexPath: indexPath)
                         }),
                UIAction(title:"Редактировать",
                         handler: { _ in
                             self.analyticService.report(event: "click",
                                                         params: [
                                                            "screen": "Main",
                                                            "item": "edit"
                                                         ])
                             self.editTracker(at: indexPath)
                         }),
                UIAction(title: "Удалить",
                         attributes: .destructive,
                         handler: { _ in
                             self.analyticService.report(event: "click",
                                                         params: [
                                                            "screen": "Main",
                                                            "item": "delete"
                                                         ])
                             self.deleteTracker(at: indexPath)
                         })
            ])
        })
    }
    
}

extension TrackerViewController: TrackerCellDelegate {
    
    func completeTracker(traker: Tracker, indexPath: IndexPath) {
        analyticService.report(event: "click", params: ["screen": "Main", "item": "track"])
        let currentDate = Date()
        let selectedDate = datePicker.date
        if selectedDate <= currentDate {
            let isIrregular = traker.schedule.isEmpty
            if isIrregular {
                categories = categories.map { category -> TrackerCategory in
                    let filteredTrackers = category.trackers.filter { $0.id != traker.id }
                    return TrackerCategory(title: category.title, trackers: filteredTrackers)
                }
                try? trackerStore.deleteTracker(with: traker.id)
                filterTrackers()
            }
            let trackerRecord = TrackerRecord(trackerId: traker.id, date: datePicker.date)
            completedTrackers.append(trackerRecord)
            recordsStore.addRecord(trackerRecord: trackerRecord)
            collectionView.reloadData()
        }
    }
    
    func uncompleteTracker(traker: Tracker, indexPath: IndexPath) {
        completedTrackers.removeAll {trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == traker.id && isSameDay
        }
        try? recordsStore.deleteTrackerRecord(with: traker.id,date: datePicker.date)
        collectionView.reloadItems(at: [indexPath])
    }
    
    private func showPlaceholder() {
        stubImageFilter.isHidden = false
        stubLabelFilter.isHidden = false
        buttonFilter.isHidden = false
        collectionView.isHidden = true
    }
    
    private func hidePlaceholder() {
        stubImageFilter.isHidden = true
        stubLabelFilter.isHidden = true
        collectionView.isHidden = false
    }
    
}

extension TrackerViewController: AddTrackerDelegate {
    func didAddTracker(_ tracker: Tracker, title: String) {
        categories = categoryStore.category
        dateValueChanged()
        collectionView.reloadData()
    }
}

extension TrackerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension TrackerViewController: TrackerStoreDelegate {
    func update() {
        collectionView.reloadData()
    }
}

extension TrackerViewController: SelectFilterDelegate {
    
    func didSelectedFilter(filter: Filters) {
        
        selectedFilter = filter.rawValue
        categories = categoryStore.category
        switch filter {
            
        case .all:
            let filterWeekday = Calendar.current.component(.weekday, from: datePicker.date)
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let dateCondition = tracker.schedule.contains { weekDay in
                        weekDay == filterWeekday
                    } || tracker.schedule.isEmpty
                    
                    return dateCondition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title,
                                       trackers: trackers)
            }
            
        case .forToday:
            datePicker.date = Date()
            let filterWeekday = Calendar.current.component(.weekday, from: datePicker.date)
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let dateCondition = tracker.schedule.contains { weekDay in
                        weekDay == filterWeekday
                    } || tracker.schedule.isEmpty
                    
                    return dateCondition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title,
                                       trackers: trackers)
            }
            
        case .completed:
            filteredCategories = categories.map { category in
                let completedTrackers = category.trackers.filter { tracker in
                    return isTrackerCompletedToday(id: tracker.id)
                }
                return TrackerCategory(title: category.title, trackers: completedTrackers)
            }.filter {!$0.trackers.isEmpty}
            collectionView.reloadData()
            
        case .notCompleted:
            filteredCategories = categories.map { category in
                let completedTrackers = category.trackers.filter { tracker in
                    return !isTrackerCompletedToday(id: tracker.id) && (isTrackerScheduledForToday(tracker: tracker) || tracker.schedule.isEmpty)
                }
                return TrackerCategory(title: category.title, trackers: completedTrackers)
            }.filter {!$0.trackers.isEmpty}
            
        }
        
        if filteredCategories.isEmpty {
            showPlaceholder()
        } else {
            hidePlaceholder()
        }
        collectionView.reloadData()
    }
    
}
