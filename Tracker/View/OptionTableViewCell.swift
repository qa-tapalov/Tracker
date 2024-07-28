//
//  DetailCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 11.04.2024.
//

import UIKit

final class OptionTableViewCell: UITableViewCell {
    
    static let optionCellIdentfier = "DetailCell"
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(resource: .black)
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return view
    }()
    
    lazy var subTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = AppColors.gray
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillEqually
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStack()
        setupTitles()
        self.backgroundColor = AppColors.lightGray.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStack(){
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupTitles(){
        stack.addArrangedSubview(title)
    }
    
    func addSubTitles(){
        stack.addArrangedSubview(subTitle)
    }
    

}
