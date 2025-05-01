//
//  NavigationManager.swift
//  ORI
//
//  Created by Song Kim on 3/6/25.
//

import UIKit

class NavigationManager {
    static func navigateToLogin() {
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

    static func navigateToTabView() {
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
