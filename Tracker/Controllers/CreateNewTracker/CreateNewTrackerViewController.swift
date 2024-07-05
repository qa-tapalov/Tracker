//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 10.04.2024.
//

import UIKit

enum Section {
    case textField
    case detail
    case emogi
    case colors
    
    var heightForSection: CGFloat {
        switch self {
        case .textField, .detail: 75
        case .emogi, .colors: 204
        }
    }
    
    var nameForSection: String? {
        switch self {
        case .textField, .detail:
            return nil
        case .emogi:
            return "Emoji"
        case .colors:
            return "Цвет"
        }
    }
}

final class CreateNewTrackerViewController: UIViewController {
    
    weak var delegate: CellCountDelegate?
    weak var delegateAddTracker: AddTrackerDelegate?
    
    private let nameOptionCell = ["Категория","Расписание"]
    private var typeTracker: String?
    private var selectedDay = [WeekDay]() {
        didSet {
            updateDoneButtonState()
        }
    }
    
    private var selectedCategory = "" {
        didSet {
            updateDoneButtonState()
        }
    }
    
    private let trackerStore = TrackerStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    
    private let viewModel: [Section] = [
        .textField,
        .detail,
        .emogi,
        .colors
    ]
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = AppColors.whiteDay
        view.separatorColor = AppColors.gray
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.keyboardDismissMode = .onDrag
        view.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.textFieldIdentifier)
        view.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.optionCellIdentfier)
        view.register(EmojiCollectionTableViewCell.self, forCellReuseIdentifier: EmojiCollectionTableViewCell.identifire)
        view.register(ColorsCollectionTableViewCell.self, forCellReuseIdentifier: ColorsCollectionTableViewCell.identifire)
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var buttonCancel: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Отменить", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColors.redBase.cgColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = AppColors.whiteDay
        view.setTitleColor(AppColors.redBase, for: .normal)
        view.addTarget(self, action: #selector(tapButtonCancel), for: .touchUpInside)
        return view
    }()
    
    private lazy var buttonCreate: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Создать", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.setTitleColor(AppColors.whiteDay, for: .normal)
        view.backgroundColor = AppColors.gray
        view.addTarget(self, action: #selector(saveTracker), for: .touchUpInside)
        view.isEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.whiteDay
        title = "Новая привычка"
        setupStack()
        setupButtonCancel()
        setupButtonCreate()
        setupTableView()
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -16)
        ])
    }
    
    private func setupStack(){
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupButtonCancel(){
        stack.addArrangedSubview(buttonCancel)
        NSLayoutConstraint.activate([
            buttonCancel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupButtonCreate(){
        stack.addArrangedSubview(buttonCreate)
        NSLayoutConstraint.activate([
            buttonCreate.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func tapButtonCancel() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTracker() throws {
        let cellTextField = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell
        let cellEmoji = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? EmojiCollectionTableViewCell
        let cellColors = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ColorsCollectionTableViewCell
        
        let name = cellTextField?.textField.text ?? "default"
        let emoji = cellEmoji?.selectedEmoji ?? "😱"
        let color = cellColors?.selectedColor ?? UIColor.gray
        
        let tracker = Tracker(id: UUID(),
                              name: name,
                              color: color,
                              emogi: emoji,
                              schedule: selectedDay.map {$0.rawValue})
        try trackerStore.addTracker(tracker: tracker, categoryTitle: selectedCategory)
        delegateAddTracker?.didAddTracker(tracker, title: selectedCategory)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldChanged() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell
        guard let text = cell?.textField.text else {return}
        if text.count >= 1 {
            updateDoneButtonState()
        }}
    
    var scheduleText: String? {
        
        if selectedDay.count == 7 {
            return "Каждый день"
        }
        
        var compactWeekend: [String] = []
        for weekday in selectedDay {
            
            var weekDay: String
            switch weekday {
                
            case .sunday:
                weekDay = "Вс"
            case .monday:
                weekDay = "Пн"
            case .thusday:
                weekDay = "Вт"
            case .wednesday:
                weekDay = "Ср"
            case .thursday:
                weekDay = "Чт"
            case .friday:
                weekDay = "Пт"
            case .saturday:
                weekDay = "Сб"
            }
            compactWeekend.append(weekDay)
        }
        return compactWeekend.joined(separator: ",")
    }
}

extension CreateNewTrackerViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = self.viewModel[indexPath.section]
        
        switch sectionType {
            
        case .textField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.textFieldIdentifier, for: indexPath) as? TextFieldTableViewCell else {return UITableViewCell()}
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            return cell
            
        case .detail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.optionCellIdentfier, for: indexPath) as? OptionTableViewCell else {return UITableViewCell()}
            cell.accessoryType = .disclosureIndicator
            cell.title.text = nameOptionCell[indexPath.row]
            
            switch indexPath.row {
            case 0: 
                if selectedCategory != "" {
                    cell.addSubTitles()
                    cell.subTitle.text = selectedCategory
                }
            case 1:
                if !selectedDay.isEmpty {
                    cell.addSubTitles()
                    cell.subTitle.text = scheduleText
                }
            default: break
            }
            
            return cell
            
        case .emogi:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmojiCollectionTableViewCell.identifire, for: indexPath) as? EmojiCollectionTableViewCell else {return UITableViewCell()}
            cell.delegate = self
            return cell
            
        case .colors:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ColorsCollectionTableViewCell.identifire, for: indexPath) as? ColorsCollectionTableViewCell else {return UITableViewCell()}
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel[section] {
            
        case .textField:
            return 1
        case .detail:
            switch typeTracker {
            case "Event": return 1
            default: return 2
            }
        case .emogi:
            return 1
        case .colors:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel[indexPath.section].heightForSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionType = self.viewModel[indexPath.section]
        switch sectionType {
            
        case .textField:
            return
        case .detail:
            switch indexPath.row {
            case 0:
                let vc = CategoriesViewController()
                vc.modalPresentationStyle = .formSheet
                vc.selectedCategory = selectedCategory
                vc.delegate = self
                self.present(UINavigationController(rootViewController:vc), animated: true)
            case 1:
                let vc = ScheduleViewController(selectedDays: selectedDay)
                vc.modalPresentationStyle = .formSheet
                vc.delegate = self
                self.present(UINavigationController(rootViewController:vc), animated: true)
                
            default: return
            }
        case .emogi:
            
            return
        case .colors:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel[section].nameForSection
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        header?.textLabel?.textColor = AppColors.blackDay
        header?.textLabel?.text = header?.textLabel?.text?.capitalizeFirstLetter()
    }
}

extension CreateNewTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 38
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension CreateNewTrackerViewController: CellCountDelegate, CellSelectedDelegate, SaveScheduleDelegate {
    func returnSchedule(_ schedule: [WeekDay]) {
        selectedDay = schedule
        tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
    }
    
    func typeTracker(_ typeTracker: String) {
        self.typeTracker = typeTracker
    }
    
    func updateDoneButtonState() {
        let isTextFieldFilled = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldTableViewCell)?.textField.text?.isEmpty == false
        let cellEmoji = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? EmojiCollectionTableViewCell
        let cellColors = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? ColorsCollectionTableViewCell
        
        let isEmojiSelected = cellEmoji?.selectedEmoji != nil
        let isColorSelected = cellColors?.selectedColor != nil
        var isScheduleSelected: Bool = false
        typeTracker == nil ? (isScheduleSelected = !selectedDay.isEmpty) : (isScheduleSelected = true)
        let isCategorySelected = selectedCategory != ""
        if isTextFieldFilled && isEmojiSelected && isColorSelected && isScheduleSelected && isCategorySelected{
            buttonCreate.backgroundColor = AppColors.blackDay
            buttonCreate.isEnabled = true
        } else {
            buttonCreate.backgroundColor = AppColors.gray
            buttonCreate.isEnabled = false
        }
    }
    
}

protocol CellSelectedDelegate: AnyObject {
    func updateDoneButtonState()
}

protocol SaveScheduleDelegate: AnyObject {
    func returnSchedule(_ schedule: [WeekDay])
}

extension CreateNewTrackerViewController: SelectCategoryDelegate {
    func didSelectCategory(_ categoryTitle: String) {
        self.selectedCategory = categoryTitle
        tableView.reloadData()
    }
}
