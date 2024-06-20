//
//  OnboardingController.swift
//  Tracker
//
//  Created by Андрей Тапалов on 17.06.2024.
//

import UIKit

final class OnboardingController: UIPageViewController {
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = AppColors.blackDay
        pageControl.pageIndicatorTintColor = AppColors.blackDay.withAlphaComponent(0.3)
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = AppColors.blackDay
        button.layer.cornerRadius = 16
        button.setTitleColor(AppColors.whiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Вот это технологии!", for: .normal)
        button.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        return button
    }()
    
    private var pages: [UIViewController] = []
    private let userStorage = UserStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func actionButton() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        userStorage.skipOnboarding = true
        window.rootViewController = tabBarController
    }
    
}

extension OnboardingController {
    
    func setupView() {
        view.addSubview(pageControl)
        view.addSubview(button)
        setupPages()
        setupConstraints()
        dataSource = self
        delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 594),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupPages() {
        let page1 = createViewController(
            imageName: "onboard_1",
            labelText: "Отслеживайте только\nто, что хотите"
        )
        let page2 = createViewController(
            imageName: "onboard_2",
            labelText: "Даже если это\nне литры воды и йога"
        )
        
        pages.append(page1)
        pages.append(page2)
        pageControl.numberOfPages = pages.count
        setViewControllers([page1], direction: .forward, animated: true, completion: nil)
    }
    
    func createViewController(imageName: String, labelText: String) -> UIViewController {
        let vc = UIViewController()
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(imageView)
        
        let label = UILabel()
        label.text = labelText
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = AppColors.blackDay
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 452),
            label.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16)
        ])
        return vc
    }
    
}

extension OnboardingController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard nextIndex < pages.count else {
            return pages[0]
        }
        
        return pages[nextIndex]
    }
    
}

extension OnboardingController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let vc = pageViewController.viewControllers?.first,
            let index = pages.firstIndex(of: vc) else
        {
            return
        }
        pageControl.currentPage = index
    }
    
}
