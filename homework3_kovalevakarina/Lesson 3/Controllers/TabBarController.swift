//
//  TabBarController.swift
//  Lesson 3
//
//  Created by Karina Kovaleva on 19.12.22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }

    private func generateTabBar() {
        guard let personImage = UIImage(systemName: "person") else { return }
        guard let favoriteImage = UIImage(systemName: "star") else { return }
        guard let selectedPersonImage = UIImage(systemName: "person.fill") else { return }
        guard let selectedFavoriteImage = UIImage(systemName: "star.fill") else { return }
        let contactListViewController = UINavigationController(rootViewController: ContactListViewController())
        contactListViewController.tabBarItem.title = String(localized: "contacts")
        contactListViewController.tabBarItem.image = personImage
        contactListViewController.tabBarItem.selectedImage = selectedPersonImage
        let favoriteContactsViewController = FavoriteContactsViewController()
        favoriteContactsViewController.tabBarItem.title = String(localized: "favorite")
        favoriteContactsViewController.tabBarItem.image = favoriteImage
        favoriteContactsViewController.tabBarItem.selectedImage = selectedFavoriteImage
        viewControllers = [contactListViewController, favoriteContactsViewController]
    }
}
 
