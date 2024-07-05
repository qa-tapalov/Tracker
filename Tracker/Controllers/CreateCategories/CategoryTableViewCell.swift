//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 21.06.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    static let categoryCellIdentifier = "CategoryCell"
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = AppColors.blackDay
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitle()
        self.backgroundColor = AppColors.lightGray.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitle(){
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
        ])
    }
    
    func configCell(title: String){
        self.title.text = title
    }
    
}
