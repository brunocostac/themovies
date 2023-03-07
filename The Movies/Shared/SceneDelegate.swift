//
//  SceneDelegate.swift
//  The Movies
//
//  Created by Bruno Costa on 27/01/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var firstTabNavigationController : UINavigationController!
    var secondTabNavigationControoller : UINavigationController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        
        let tabBarController = CustomTabBarController()
        
        
        firstTabNavigationController = UINavigationController.init(rootViewController: HomeViewController())
        secondTabNavigationControoller = UINavigationController.init(rootViewController: FavoritesTableViewController())
        
        tabBarController.viewControllers = [firstTabNavigationController, secondTabNavigationControoller]
        
        let item1 = UITabBarItem(title: "Movies", image: UIImage(systemName: "house"), tag: 0)
        
        let item2 = UITabBarItem(title: "Favorites", image:  UIImage(systemName: "star.fill"), tag: 1)
        
        
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationControoller.tabBarItem = item2
       
       
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

