//
//  TabBarController.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 04/07/22.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    func setupViewController() {

        let tabViewController1 = ListViewController(nibName: "ListViewController", bundle: nil)
        let firstNavigationController = UINavigationController(rootViewController: tabViewController1)
        firstNavigationController.tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let tabViewController2 = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)
        let secondNavigationController = UINavigationController(rootViewController: tabViewController2)
        secondNavigationController.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart"))
        
        let tabViewController3 = ComprasViewController()
        let thirdNavigationController = UINavigationController(rootViewController: tabViewController3)
        thirdNavigationController.tabBarItem = UITabBarItem(title: "Compras", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag"))
        
        let tabViewController4 = NotificacoesViewController()
        let forthNavigationController = UINavigationController(rootViewController: tabViewController4)
        forthNavigationController.tabBarItem = UITabBarItem(title: "Notificações", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell"))
        
        let tabViewController5 = MaisViewController()
        let fithNavigationController =  UINavigationController(rootViewController: tabViewController5)
        fithNavigationController.tabBarItem = UITabBarItem(title: "Mais", image: UIImage(systemName: "line.3.horizontal"), selectedImage: UIImage(systemName: "line.3.horizontal"))
        
        viewControllers = [firstNavigationController,secondNavigationController, thirdNavigationController, forthNavigationController, fithNavigationController]
    }
    
}
