//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 12.04.2024.
//
import UIKit

final class EmojiCollectionTableViewCell: UITableViewCell {
    
    static let identifire = "EmojiCollectionTableViewCell"
    weak var delegate: CellSelectedDelegate?
    var selectedEmoji: String? {
        didSet {
            delegate?.updateDoneButtonState()
        }
    }
    private let emogis: [String] = [
        "🙂", "😻", "🌺",
        "🐶", "❤️", "😱",
        "😇", "😡", "🥶",
        "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇",
        "🎸", "🏝", "😪"
    ]
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmogiCollectionViewCell.self, forCellWithReuseIdentifier: EmogiCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

extension EmojiCollectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emogis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmogiCollectionViewCell.identifier, for: indexPath) as? EmogiCollectionViewCell else {return UICollectionViewCell()}
        cell.backgroundColor = UIColor(resource: .white)
        cell.titleLabel.text = emogis[indexPath.row]
        
        if let indexEmoji = emogis.firstIndex(of: selectedEmoji ?? "") {
            if indexPath.row == indexEmoji {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [] )
                cell.backgroundColor = AppColors.lightGray
                cell.layer.cornerRadius = 16
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = AppColors.lightGray
        cell?.layer.cornerRadius = 16
        selectedEmoji = emogis[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
        cell?.layer.cornerRadius = 0
    }
}

final class EmogiCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    static let identifier = "EmogiCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
