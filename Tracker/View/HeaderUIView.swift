//
//  HeaderUIView.swift
//  Tracker
//
//  Created by Андрей Тапалов on 23.07.2024.
//

import UIKit

final class HeaderUIView: UIView {
    
    lazy var label: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(resource: .black)
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
