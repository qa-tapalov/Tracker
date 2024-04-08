//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.04.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
    }
    
    private func setupView(){
        view.backgroundColor = AppColors.whiteDay
        title = "Статистика"
    }

}
