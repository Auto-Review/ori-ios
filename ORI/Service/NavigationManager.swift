//
//  NavigationManager.swift
//  ORI
//
//  Created by Song Kim on 3/6/25.
//

import UIKit

class NavigationManager {
    func navigateToLogin() {
        DispatchQueue.main.async {
            let tabBarController = LoginViewController()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                }
            }
        }
    }

    func navigateToTabView() {
        DispatchQueue.main.async {
            let tabBarController = TabViewController()
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                }
            }
        }
    }
}
