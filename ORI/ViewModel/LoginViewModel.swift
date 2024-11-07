//
//  LoginViewModel.swift
//  ORI
//
//  Created by Song Kim on 11/7/24.
//

import GoogleSignIn

class LoginViewModel {
    func didReceiveUserAccessToken(_ token: String, email: String) {
        print("Received Access Token: \(token)")
        print("Received Email: \(email)")
    }

    func moveToMain() {
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

class LogOutManager {
    func logOut(isGoole: Bool) {
        if isGoole {
            GIDSignIn.sharedInstance.signOut()
        } else {
            GitLoginManager.shared.logout()
        }
        
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
