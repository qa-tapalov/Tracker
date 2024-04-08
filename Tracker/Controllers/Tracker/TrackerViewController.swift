//
//  ViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.04.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    private lazy var labelEmptyList: UILabel = {
        let view = UILabel()
        view.text = "Что будем отслеживать?"
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stubImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .stubEmptyList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .compact
        view.date = Calendar.current.startOfDay(for: Date())
        return view
    }()
    
    var categories: [TrackerCategory]
    var completedTrackers: [TrackerRecord]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureNavBar()
    }
    
    private func configureNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView(){
        view.backgroundColor = AppColors.whiteDay
        view.addSubview(stubImage)
        view.addSubview(labelEmptyList)
        title = "Трекер"
        setupConstraitsStubImage()
        setupConstraitsLabelEmptyList()
    }
    
    private func setupConstraitsStubImage(){
        NSLayoutConstraint.activate([
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupConstraitsLabelEmptyList(){
        NSLayoutConstraint.activate([
            labelEmptyList.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            labelEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

