//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.04.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private lazy var stubImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .stubEmptyStatistic)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelEmptyList: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString("emptyStatistics", comment: "Title for empty statistic")
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.backgroundColor = UIColor(resource: .white)
        view.separatorColor = AppColors.gray
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.isScrollEnabled = false
        view.register(StatisticTableViewCell.self, forCellReuseIdentifier: StatisticTableViewCell.statisticCellIdentfier)
        return view
    }()
    
    private var completedTrackers: [TrackerRecord] = []
    private let trackerRecordsStore = TrackerRecordStore.shared
    private let trackerView = TrackerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completedTrackers = trackerRecordsStore.trackerRecords
        setupView()
    }
}

private extension StatisticViewController {
    
    private func setupView(){
        view.backgroundColor = UIColor(resource: .white)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = NSLocalizedString("StatisticsTitle", comment: "Title for statistic tab")
        view.addSubview(stubImage)
        view.addSubview(labelEmptyList)
        view.addSubview(tableView)
        setupStubImage()
        setupLabelEmptyList()
        setupTableView()
        trackerRecordsStore.delegate = self
    }
    
    private func setupStubImage(){
        NSLayoutConstraint.activate([
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupLabelEmptyList(){
        NSLayoutConstraint.activate([
            labelEmptyList.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            labelEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView(){
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -126)
        ])
    }
    
}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if completedTrackers.isEmpty {
            stubImage.isHidden = false
            labelEmptyList.isHidden = false
            tableView.isHidden = true
            return 0
        } else {
            stubImage.isHidden = true
            labelEmptyList.isHidden = true
            tableView.isHidden = false
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticTableViewCell.statisticCellIdentfier, for: indexPath) as? StatisticTableViewCell else { return UITableViewCell()}
        let title = completedTrackers.count
        let subTitle = "Трекеров завершено"
        cell.configCell(count: title, subTitle: subTitle)
        cell.selectionStyle = .none
        return cell
    }
}

extension StatisticViewController: TrackerRecordDelegate {
    func updateRecords() {
        completedTrackers = trackerRecordsStore.trackerRecords
        tableView.reloadData()
    }
}
