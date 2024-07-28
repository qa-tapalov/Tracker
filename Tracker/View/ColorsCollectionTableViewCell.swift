//
//  ColorsCollectionTableViewCell.swift
//  Tracker
//
//  Created by Андрей Тапалов on 12.04.2024.
//

import UIKit

final class ColorsCollectionTableViewCell: UITableViewCell {
    
    static let identifire = "ColorsCollectionTableViewCell"
    weak var delegate: CellSelectedDelegate?
    var selectedColor: UIColor? {
        didSet {
            delegate?.updateDoneButtonState()
        }
    }
    
    private let colors: [UIColor] = [
        AppColors.red, AppColors.orange, AppColors.bluePallet, AppColors.purple, AppColors.green, AppColors.magenta,
        AppColors.lightPink, AppColors.paleBlue, AppColors.brightGreen, AppColors.darkBlue, AppColors.deepOrange, AppColors.pink,
        AppColors.sand, AppColors.lightBlue, AppColors.darkPurple, AppColors.darkMagenta, AppColors.lavender, AppColors.limeGreen
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

extension ColorsCollectionTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell else {return UICollectionViewCell()}
        cell.viewColor.backgroundColor = colors[indexPath.row]
        
        if let index = colors.firstIndex(of: selectedColor ?? .background) {
            if indexPath.row == index {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [] )
                cell.layer.borderColor = colors[indexPath.row].cgColor
                cell.layer.borderWidth = 3
                cell.layer.cornerRadius = 8
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = colors[indexPath.row].cgColor
        cell?.layer.borderWidth = 3
        cell?.layer.cornerRadius = 8
        selectedColor = colors[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
}

final class ColorCollectionViewCell: UICollectionViewCell {
    let viewColor = UIView()
    static let identifier = "ColorCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(viewColor)
        viewColor.translatesAutoresizingMaskIntoConstraints = false
        viewColor.layer.cornerRadius = 8
        NSLayoutConstraint.activate([
            viewColor.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            viewColor.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewColor.widthAnchor.constraint(equalToConstant: 40),
            viewColor.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
