//
//  MainTabController.swift
//  DriveMusic
//
//  Created by Quasar on 23.10.2023.
//

import UIKit

class MainTabController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundColor = UIColor.gray
        UITabBar.appearance().tintColor = UIColor(hexValue: "#FD2D55", alpha: 1)
        
        viewControllers = [ generateVC(rootViewController: SearchViewController(), image: UIImage(imageLiteralResourceName: "ios10-apple-music-search-5nav-icon"), title: "Search"),
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
}
