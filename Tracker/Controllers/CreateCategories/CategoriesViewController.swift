//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 17.04.2024.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    private lazy var stubImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .stubEmptyList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelEmptyList: UILabel = {
        let view = UILabel()
        view.text = "Привычки и события можно\nобъединить по смыслу"
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 2
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.blackDay
        view.layer.cornerRadius = 16
        view.setTitle("Добавить категорию", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.titleLabel?.textColor = AppColors.whiteDay
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension CategoriesViewController {
    
    private func setupView(){
        title = "Категория"
        view.backgroundColor = AppColors.whiteDay
        view.addSubview(button)
        view.addSubview(stubImage)
        view.addSubview(labelEmptyList)
        setupButton()
        setupStubImage()
        setupLabelEmptyList()
    }
    
    private func setupButton(){
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
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
}
