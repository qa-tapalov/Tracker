//
//  TrackerViewCollectionCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 09.04.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(traker: Tracker, indexPath: IndexPath)
    func uncompleteTracker(traker: Tracker, indexPath: IndexPath)
}

final class TrackerViewCollectionCell: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleNameTracker: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.textColor = AppColors.whiteDay
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emogiLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.textAlignment = .center
        view.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var daysLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonDone: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.layer.cornerRadius = 17
        view.tintColor = .white
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(buttonCompleteTap), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonPin: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        view.tintColor = AppColors.whiteDay
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    static let reuseIdentifier = "TrackerCollectionViewCell"
    weak var delegate: TrackerCellDelegate?
    private var isCompletedToday: Bool = false
    private var tracker: Tracker?
    private var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.tracker = tracker
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        self.containerView.backgroundColor = tracker.color
        self.buttonDone.backgroundColor = tracker.color
        self.daysLabel.text = pluralizeDays(completedDays)
        self.titleNameTracker.text = tracker.name
        self.emogiLabel.text = tracker.emogi
        if isCompletedToday {
            self.buttonDone.setImage(UIImage(systemName: "checkmark"), for: .normal)
            self.buttonDone.backgroundColor = tracker.color.withAlphaComponent(0.3)
        } else {
            self.buttonDone.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    private func setup(){
        contentView.addSubview(containerView)
        containerView.addSubview(emogiLabel)
        containerView.addSubview(titleNameTracker)
        contentView.addSubview(daysLabel)
        contentView.addSubview(buttonDone)
        containerView.addSubview(buttonPin)
        setupConstraitsLabel()
        setupCostraitsContainer()
        setupCostraitsEmogiLabel()
        setupCostraitsDaysLabel()
        setupCostraitsButtonDone()
        setupCostraitsButtonPin()
    }
    
    private func setupConstraitsLabel(){
        NSLayoutConstraint.activate([
            titleNameTracker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleNameTracker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleNameTracker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupCostraitsContainer(){
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    private func setupCostraitsEmogiLabel(){
        NSLayoutConstraint.activate([
            emogiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emogiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emogiLabel.widthAnchor.constraint(equalToConstant: 24),
            emogiLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setupCostraitsDaysLabel(){
        NSLayoutConstraint.activate([
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupCostraitsButtonDone(){
        NSLayoutConstraint.activate([
            buttonDone.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            buttonDone.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buttonDone.widthAnchor.constraint(equalToConstant: 34),
            buttonDone.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupCostraitsButtonPin(){
        NSLayoutConstraint.activate([
            buttonPin.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            buttonPin.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            buttonPin.widthAnchor.constraint(equalToConstant: 24),
            buttonPin.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func buttonCompleteTap(){
        
        guard let tracker, let indexPath else {return}
        
        if isCompletedToday {
            delegate?.uncompleteTracker(traker: tracker, indexPath: indexPath)
        } else {
            delegate?.completeTracker(traker: tracker, indexPath: indexPath)
        }
    }
    
    private func pluralizeDays(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) день"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "\(count) дня" }
        else {
            return "\(count) дней"
        }
    }
}
