//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Андрей Тапалов on 15.04.2024.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    
    var title = UILabel()
    static let supplementaryIdentifier = "header"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleView()
    }
    
    func setupTitleView(){
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = AppColors.blackDay
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            title.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
