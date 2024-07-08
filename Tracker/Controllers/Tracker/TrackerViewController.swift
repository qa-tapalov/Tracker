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

final class TrackerViewController: UIViewController {
    
    var filteredCategories: [TrackerCategory] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    private let trackerStore = TrackerStore.shared
    private let recordsStore = TrackerRecordStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    private lazy var labelEmptyList: UILabel = {
        let view = UILabel()
        view.text = "Что будем отслеживать?"
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
        return view
    }()
    
    weak var delegate: TrackerStoreDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Трекер"
        
        setupView()
        trackerStore.delegate = self
        fetchData()
        dateValueChanged()
        configureNavBar()
    }
    
    private func fetchData(){
        categories = categoryStore.category
        completedTrackers = recordsStore.fetchTrackerRecords()
    }
    
    private func configureNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(addTracker))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView(){
        view.backgroundColor = AppColors.whiteDay
        view.addSubview(stubImage)
        view.addSubview(labelEmptyList)
        view.addSubview(collectionView)
        view.addSubview(searchTextField)
        setupCollection()
        setupConstraitsStubImage()
        setupConstraitsLabelEmptyList()
        setupConstraitsSearchBar()
        collectionView.register(TrackerViewCollectionCell.self, forCellWithReuseIdentifier: TrackerViewCollectionCell.reuseIdentifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.supplementaryIdentifier)
    }
    
    private func setupCollection(){
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
    }
    
    private func setupConstraitsLabelEmptyList(){
        NSLayoutConstraint.activate([
            labelEmptyList.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            labelEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
    @objc private func dateValueChanged(){
        filterTrackers()
        collectionView.reloadData()
    }
    
    @objc private func addTracker(){
        let vc = CreateTrackerViewController()
        vc.modalPresentationStyle = .formSheet
        vc.delegateAddTracker = self
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func filterTrackers(){
        let selectedDate = datePicker.date
        let filterWeekday = Calendar.current.component(.weekday, from: selectedDate)
        let filterText = searchTextField.text?.lowercased() ?? ""
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
}

extension TrackerViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if filteredCategories.isEmpty {
            collectionView.isHidden = true
            stubImage.isHidden = false
            labelEmptyList.isHidden = false
        } else {
            stubImage.isHidden = true
            labelEmptyList.isHidden = true
            collectionView.isHidden = false
            
        }
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
        let completedDays = completedTrackers.filter {$0.trackerId == tracker.id}.count
        cell.configure(tracker: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, indexPath: indexPath)
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == id && isSameDay
        }
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
}

extension TrackerViewController: TrackerCellDelegate {
    
    func completeTracker(traker: Tracker, indexPath: IndexPath) {
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
        filterTrackers()
        collectionView.reloadData()
        return true
    }
    
}

extension TrackerViewController: TrackerStoreDelegate {
    func update() {
        collectionView.reloadData()
    }
    
}
