//
//  TextFieldCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 11.04.2024.
//

import UIKit

final class TextFieldTableViewCell: UITableViewCell {
    
    static let textFieldIdentifier = "TextFieldTableViewCell"
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: [NSAttributedString.Key.foregroundColor: AppColors.gray,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        view.textColor = AppColors.blackDay
        view.backgroundColor = AppColors.lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.setLeftPaddingPoints(16)
        view.borderStyle = .none
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField(){
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

