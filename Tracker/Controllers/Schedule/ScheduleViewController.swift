//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 11.04.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    weak var delegate: SaveScheduleDelegate?
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let daysOfWeek = ["Понедельник","Вторник","Среда","Четверг","Пятница","Суббота","Воскресенье"]
    private let weekday: [WeekDay] = [.monday,.thusday,.wednesday,.thursday,.friday,.saturday,.sunday,]
    private var selectedDays = [WeekDay]()
    
    init(selectedDays: [WeekDay]){
        super.init(nibName: nil, bundle: nil)
        self.selectedDays = selectedDays
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var buttonDone: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Готово", for: .normal)
        view.backgroundColor = AppColors.blackDay
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(saveSchedule), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = AppColors.whiteDay
        setupView()
    }
    
    private func setupView(){
        view.addSubview(tableView)
        view.addSubview(buttonDone)
        setupButtonDone()
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColors.whiteDay
        tableView.separatorColor = AppColors.gray
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.scheduleCell)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonDone.topAnchor, constant: -16)
        ])
    }
    
    private func setupButtonDone(){
        NSLayoutConstraint.activate([
            buttonDone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonDone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonDone.heightAnchor.constraint(equalToConstant: 60),
            buttonDone.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.scheduleCell, for: indexPath) as? ScheduleTableViewCell else {return UITableViewCell()}
        cell.title.text = daysOfWeek[indexPath.row]
        cell.switchView.tag = indexPath.row
        cell.switchView.isOn = selectedDays.contains(weekday[indexPath.row])
        cell.switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return cell
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let dayIndex = sender.tag
        let weekday = weekday[dayIndex]
        let isSwitchOn = sender.isOn
        
        if isSwitchOn {
            selectedDays.append(weekday)
        } else {
            if let index = selectedDays.firstIndex(of: weekday) {
                selectedDays.remove(at: index)
            }
        }
    }
    
    @objc private func saveSchedule(){
        print(selectedDays)
        delegate?.returnSchedule(selectedDays)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ScheduleTableViewCell
        cell.switchView.isOn = !cell.switchView.isOn
        switchChanged(cell.switchView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
