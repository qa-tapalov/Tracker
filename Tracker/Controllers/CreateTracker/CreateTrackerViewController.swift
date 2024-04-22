//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 10.04.2024.
//

import UIKit

protocol CellCountDelegate: AnyObject {
    func typeTracker(_ typeTracker: String)
}

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CellCountDelegate?
    weak var delegateAddTracker: AddTrackerDelegate?
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonCreateHabit: UIButton = {
        let view = UIButton()
        view.setTitle("Привычка", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(createHabit(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var buttonCreateEvent: UIButton = {
        let view = UIButton()
        view.setTitle("Нерегулярное событие", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(createEvent(_:)), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.whiteDay
        title = "Создание трекера"
        setupStackView()
        setupButtonHabit()
        setupButtonEvent()
    }
    
    private func setupStackView(){
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupButtonHabit(){
        stack.addArrangedSubview(buttonCreateHabit)
        buttonCreateHabit.backgroundColor = AppColors.blackDay
        buttonCreateHabit.layer.cornerRadius = 16
        buttonCreateHabit.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            buttonCreateHabit.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            buttonCreateHabit.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            buttonCreateHabit.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupButtonEvent(){
        stack.addArrangedSubview(buttonCreateEvent)
        buttonCreateEvent.backgroundColor = AppColors.blackDay
        buttonCreateEvent.layer.cornerRadius = 16
        buttonCreateEvent.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            buttonCreateEvent.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            buttonCreateEvent.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            buttonCreateEvent.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func createHabit(_ sender: UIButton) {
        let vc = CreateNewTrackerViewController()
        vc.modalPresentationStyle = .formSheet
        vc.delegateAddTracker = delegateAddTracker
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc func createEvent(_ sender: UIButton) {
        let vc = CreateNewTrackerViewController()
        vc.modalPresentationStyle = .formSheet
        self.delegate = vc
        vc.delegateAddTracker = delegateAddTracker
        self.present(UINavigationController(rootViewController: vc), animated: true)
        delegate?.typeTracker("Event")
    }
}
