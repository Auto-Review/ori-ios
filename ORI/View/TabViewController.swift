//
//  TabViewController.swift
//  ORI
//
//  Created by Song Kim on 10/4/24.
//

import UIKit

class TabViewController: UIViewController {
    
    let tabBarVC = UITabBarController()
    
    let vc1 = UINavigationController(rootViewController: TCLListViewController())
    let vc2 = CodeListViewController()
    let vc3 = PostViewController()
    let vc4 = NotifyViewController()
    let vc5 = ProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customTabBar = CustomTabBar()
        tabBarVC.setValue(customTabBar, forKey: "tabBar")
        
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "line.horizontal.3")
        items[1].image = UIImage(systemName: "chevron.left.forwardslash.chevron.right")
        items[2].image = UIImage(systemName: "square.and.pencil")
        items[3].image = UIImage(systemName: "bell")
        items[4].image = UIImage(systemName: "person")
        
        addChild(tabBarVC)
        view.addSubview(tabBarVC.view)
        tabBarVC.view.frame = view.bounds
        tabBarVC.didMove(toParent: self)
    }
}

// MARK: 커스텀 탭바
class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 100
        return size
    }
}
