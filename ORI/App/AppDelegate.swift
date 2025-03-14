//
//  AppDelegate.swift
//  ORI
//
//  Created by Song Kim on 10/4/24.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let googleHandled = GIDSignIn.sharedInstance.handle(url)

        LogoutManager.checkAndHandleTokenExpiration()

        return googleHandled
    }
}
