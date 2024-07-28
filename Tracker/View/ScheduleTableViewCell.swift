//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 11.04.2024.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    
    static let scheduleCell = "ScheduleTableViewCell"
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(resource: .black)
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return view
    }()
    
    lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = AppColors.blue
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 2
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = AppColors.lightGray.withAlphaComponent(0.3)
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStack(){
        contentView.addSubview(stack)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(switchView)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}


