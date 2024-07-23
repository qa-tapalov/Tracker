//
//  Filters.swift
//  Tracker
//
//  Created by Андрей Тапалов on 19.07.2024.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(resource: .white)
        view.separatorColor = AppColors.gray
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.isScrollEnabled = false
        view.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.categoryCellIdentifier)
        return view
    }()
    
    var selectedFilter = ""
    weak var delegate: SelectFilterDelegate?
    private let cellDataSource: [Filters] = [.all,.forToday,.completed,.notCompleted]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

private extension FiltersViewController {
    private func setupView(){
        title = "Фильтры"
        view.backgroundColor = UIColor(resource: .white)
        view.addSubview(tableView)
        setupTableView()
    }
    
    private func setupTableView(){
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedFilter = cellDataSource[indexPath.row].rawValue
        tableView.reloadData()
        delegate?.didSelectedFilter(filter: cellDataSource[indexPath.row])
        dismiss(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.categoryCellIdentifier, for: indexPath) as? CategoryTableViewCell else {return UITableViewCell()}
        
        let index = cellDataSource.firstIndex {$0.rawValue == selectedFilter}
        if index == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        let title = cellDataSource[indexPath.row].rawValue
        cell.configCell(title: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
}
