//
//  TabBarController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 04.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar(){
        tabBar.backgroundColor = UIColor(resource: .white)
        
        let vc1 = UINavigationController(rootViewController: TrackerViewController())
        let vc2 = UINavigationController(rootViewController: StatisticViewController())
        vc1.tabBarItem.image = UIImage(resource: .trackerListTabBar)
        vc2.tabBarItem.image = UIImage(resource: .statisticsTabBar)
        vc1.title = NSLocalizedString("TrackersTitle", comment: "Title for trackers tab")
        vc2.title = NSLocalizedString("StatisticsTitle", comment: "Title for statistic tab")
        
        let lineView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width:tabBar.frame.size.width,
                                            height: 1))
        lineView.backgroundColor = AppColors.gray
        tabBar.addSubview(lineView)
        
        setViewControllers([vc1,vc2], animated: true)
    }
}
