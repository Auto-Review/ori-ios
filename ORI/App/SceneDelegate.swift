//
//  SceneDelegate.swift
//  ORI
//
//  Created by Song Kim on 10/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
//        let mainViewController = LoginViewController()
        let mainViewController = TabViewController()

        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}

