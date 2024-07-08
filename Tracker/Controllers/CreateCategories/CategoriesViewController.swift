//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 17.04.2024.
//

import UIKit

protocol SelectCategoryDelegate: AnyObject {
    func didSelectCategory(_ categoryTitle: String)
}

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
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = AppColors.whiteDay
        view.separatorColor = AppColors.gray
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.keyboardDismissMode = .onDrag
        view.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.categoryCellIdentifier)
        return view
    }()
    
    private var viewModel: CategoryViewModelProtocol?
    var selectedCategory = ""
    private var cellDataSource: [TrackerCategory] = []
    weak var delegate: SelectCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = CategoryViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonAction(){
        let vc = CreateNewCategoryViewController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        self.present(UINavigationController(rootViewController:vc), animated: true)
    }
    
    private func bindViewModel(){
        viewModel?.cellCategoryDataSource.bind { [weak self] category in
            guard let self, let category else { return }
            DispatchQueue.main.async {
                self.cellDataSource = category
                self.tableView.reloadData()
            }
        }
    }
}
//MARK: - UI extension
private extension CategoriesViewController {
    
    private func setupView(){
        title = "Категория"
        view.backgroundColor = AppColors.whiteDay
        view.addSubview(button)
        view.addSubview(stubImage)
        view.addSubview(labelEmptyList)
        view.addSubview(tableView)
        setupButton()
        setupTableView()
        setupStubImage()
        setupLabelEmptyList()
        viewModel?.fetchCategory()
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16)
        ])
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
//MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCategory = cellDataSource[indexPath.row].title
        tableView.reloadData()
        delegate?.didSelectCategory(selectedCategory)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPath.count > 0 else {
            return nil
        }
        
        let category = cellDataSource[indexPath.row]
        
        return UIContextMenuConfiguration(actionProvider: {action in
            return UIMenu(children: [
                UIAction(title: "Удалить", attributes: .destructive, handler: { [weak self] _ in
                    let alert = UIAlertController(title: "Эта категория точно не нужна?", message: nil, preferredStyle: .actionSheet)
                    let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                        try? self?.viewModel?.deleteCategory(category: category)
                    }
                    let cancel = UIAlertAction(title: "Отменить", style: .cancel)
                    alert.addAction(deleteAction)
                    alert.addAction(cancel)
                    self?.present(alert, animated: true)
                })
            ])
        })
    }
}
//MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.numbersOfRows() == 0 {
            tableView.isHidden = true
            stubImage.isHidden = false
            labelEmptyList.isHidden = false
        } else {
            stubImage.isHidden = true
            labelEmptyList.isHidden = true
            tableView.isHidden = false
        }
        return cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.categoryCellIdentifier, for: indexPath) as? CategoryTableViewCell else {return UITableViewCell()}
        
        let index = cellDataSource.firstIndex {$0.title == selectedCategory}
        if index == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        let title = cellDataSource[indexPath.row].title
        cell.configCell(title: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
//MARK: - NewCategoryDelegate
extension CategoriesViewController: NewCategoryDelegate {
    func didAddNewCategory(_ category: TrackerCategory) throws {
        try viewModel?.addCategory(category: category)
    }
}
