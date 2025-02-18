//
//  TabViewController.swift
//  ORI
//
//  Created by Song Kim on 10/4/24.
//

import UIKit

class TabViewController: UIViewController {
    
    let tabBarVC = UITabBarController()
    
    let vc1 = UINavigationController(rootViewController: CodeListViewController())
    let vc2 = UINavigationController(rootViewController: TILListViewController())
    let vc3 = UINavigationController(rootViewController: MainViewController())
    let vc4 = UINavigationController(rootViewController: ProfileViewController())
    let vc5 = UINavigationController(rootViewController: SettingViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customTabBar = UITabBar()
        tabBarVC.setValue(customTabBar, forKey: "tabBar")

        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabBarVC.tabBar.standardAppearance = appearance
        tabBarVC.tabBar.scrollEdgeAppearance = appearance
        
        tabBarVC.tabBar.isTranslucent = false // 투명도 제거
        tabBarVC.tabBar.tintColor = .white
        
        guard let items = tabBarVC.tabBar.items else { return }
        let tabTitles = ["CODE", "TIL", "MAIN", "MY", "SET"]
        let tabImages = [
            "chevron.left.forwardslash.chevron.right",
            "checkmark.circle",
            "house",
            "person",
            "gearshape"
        ]
        
        for (index, item) in items.enumerated() {
            let image = UIImage(systemName: tabImages[index],withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
            let boldImage = UIImage(systemName: tabImages[index], withConfiguration: UIImage.SymbolConfiguration(pointSize: 15,weight: .bold))

            item.image = image
            item.selectedImage = boldImage
            item.title = tabTitles[index]
        }
        
        addChild(tabBarVC)
        view.addSubview(tabBarVC.view)
    }
}


class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 90
        return size
    }
}
