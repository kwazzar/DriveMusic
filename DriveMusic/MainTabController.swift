//
//  MainTabController.swift
//  DriveMusic
//
//  Created by Quasar on 23.10.2023.
//

import UIKit

protocol MainTabControllerDelegate: AnyObject {
    func minimazeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabController: UITabBarController {

    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor(hexValue: "#FD2D55", alpha: 1)
        setupTrackDetailView()

        searchVC.tabBarDelegate = self

        viewControllers = [ generateVC(rootViewController: searchVC, image: UIImage(imageLiteralResourceName: "ios10-apple-music-search-5nav-icon"), title: "Search"),
                            generateVC(rootViewController: ViewController(), image: UIImage(imageLiteralResourceName: "ios10-apple-music-library-5nav-icon"), title: "Library")
        ]
    }
    
    private func generateVC(rootViewController: UIViewController, image : UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }

    private func setupTrackDetailView() {
        print("Трек детайл налаштування")

        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)

        // Use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false

        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true

        maximizedTopAnchorConstraint.isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension MainTabController: MainTabControllerDelegate {

    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maxizedStackView.alpha = 1
        },
                       completion: nil)

        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }

    func minimazeTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maxizedStackView.alpha = 0
        },
                       completion: nil)
    }
}
