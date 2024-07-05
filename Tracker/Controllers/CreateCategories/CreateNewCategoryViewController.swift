//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 25.06.2024.
//

import UIKit

protocol NewCategoryDelegate: AnyObject {
    func didAddNewCategory(_ category: TrackerCategory) throws
}

final class CreateNewCategoryViewController: UIViewController {
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.attributedPlaceholder = NSAttributedString(string: "Введите название категории", attributes: [NSAttributedString.Key.foregroundColor: AppColors.gray,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        view.textColor = AppColors.blackDay
        view.backgroundColor = AppColors.lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.setLeftPaddingPoints(16)
        view.borderStyle = .none
        view.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppColors.blackDay
        view.layer.cornerRadius = 16
        view.setTitle("Готово", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = AppColors.gray
        view.isEnabled = false
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    weak var delegate: NewCategoryDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func textFieldChanged() {
        guard let text = textField.text else {return}
        if text.count >= 1 {
            button.backgroundColor = AppColors.blackDay
            button.isEnabled = true
        } else {
            button.backgroundColor = AppColors.gray
            button.isEnabled = false
        }
    }
    
    @objc func buttonAction() throws {
        guard let categoryName = textField.text else {return}
        let newCategory = TrackerCategory(title: categoryName, trackers: [])
        try delegate?.didAddNewCategory(newCategory)
        dismiss(animated: true)
    }
}
//MARK: - UI extension
private extension CreateNewCategoryViewController {
    
    private func setupView(){
        title = "Новая категория"
        view.backgroundColor = AppColors.whiteDay
        view.addSubview(textField)
        view.addSubview(button)
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 75),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
//MARK: - UITextFieldDelegate
extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
