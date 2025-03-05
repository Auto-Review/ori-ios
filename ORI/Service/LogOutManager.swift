//
//  LogOutManager.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import UIKit
import GoogleSignIn

class LogOutManager {
    func logOut() {
        GIDSignIn.sharedInstance.signOut()
        moveToMain()
    }
    
    func moveToLogin() {
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
}
        
