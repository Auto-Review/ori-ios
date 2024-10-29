//
//  TabViewController.swift
//  ORI
//
//  Created by Song Kim on 10/4/24.
//

import UIKit

class TabViewController: UIViewController {
    
    let tabBarVC = UITabBarController()
    
    let vc1 = UINavigationController(rootViewController: TILListViewController())
    let vc2 = UINavigationController(rootViewController: CodeListViewController())
    let vc3 = UINavigationController(rootViewController: PostViewController())
    let vc4 = UINavigationController(rootViewController: NotifyViewController())
    let vc5 = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customTabBar = CustomTabBar()
        tabBarVC.setValue(customTabBar, forKey: "tabBar")
        
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        
        tabBarVC.tabBar.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.85)
        
        tabBarVC.tabBar.tintColor = .oriYellow
        tabBarVC.tabBar.unselectedItemTintColor = .systemGray2
        
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .bold)
        
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "square.text.square", withConfiguration: boldConfig)
        items[1].image = UIImage(systemName: "chevron.left.forwardslash.chevron.right", withConfiguration: boldConfig)
        items[2].image = UIImage(systemName: "square.and.pencil", withConfiguration: boldConfig)
        items[3].image = UIImage(systemName: "bell", withConfiguration: boldConfig)
        items[4].image = UIImage(systemName: "person", withConfiguration: boldConfig)
        
        addChild(tabBarVC)
        view.addSubview(tabBarVC.view)
        tabBarVC.view.frame = view.bounds.insetBy(dx: 0, dy: -10)
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
