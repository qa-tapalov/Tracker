//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 08.07.2024.
//

import UIKit

final class StatisticTableViewCell: UITableViewCell {
    
    static let statisticCellIdentfier = "StatisticCell"
    
    lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = AppColors.blackDay
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return view
    }()
    
    lazy var subTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = AppColors.blackDay
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        setupViews()
        self.backgroundColor = AppColors.whiteDay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStack(){
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupViews(){
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(subTitle)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.clipsToBounds = true
        let gradient = UIImage.gradientImage(bounds: contentView.bounds, colors: [.red, .green, .blue])
        let color = UIColor(patternImage: gradient)
        contentView.layer.borderColor = color.cgColor
    }
    
    func configCell(count: Int, subTitle: String){
        self.title.text = String(count)
        self.subTitle.text = renameSubTitle(subTitle: subTitle, count: count)
    }
    
    private func renameSubTitle(subTitle: String, count: Int) -> String{
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "Трекер завершен"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "Трекера завершено" }
        else {
            return "Трекеров завершено"
        }
    }
    
}



