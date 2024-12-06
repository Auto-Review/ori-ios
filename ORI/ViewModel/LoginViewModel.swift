//
//  LoginViewModel.swift
//  ORI
//
//  Created by Song Kim on 11/7/24.
//

import GoogleSignIn
import Alamofire
import KeychainSwift

class LoginViewModel {
    let keychain = KeychainSwift()

    func didReceiveUserAccessToken(_ token: String, email: String) {
        sendTokenToServer(accessToken: token) { [weak self] serverTokenResponse in
            guard let self = self else { return }
            self.keychain.set(serverTokenResponse.accessToken, forKey: "accessToken")
            self.keychain.set(serverTokenResponse.refreshToken, forKey: "refreshToken")
            print("New tokens saved to Keychain")
        }
    }

    private func sendTokenToServer(accessToken: String, completion: @escaping (ServerTokenResponse) -> Void) {
        let api_url = Bundle.main.infoDictionary?["SERVER_API_URL"] as? String ?? ""
        let url = "\(api_url)v1/api/auth/token"
        let parameters: [String: String] = ["accessToken": accessToken]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    guard let httpResponse = response.response else {
                        print("No HTTP response available")
                        return
                    }

                    if let accessToken = httpResponse.headers["accesstoken"],
                       let refreshToken = httpResponse.headers["refreshtoken"] {
                        print("Received tokens from server:")
                        print("Access Token: \(accessToken)")
                        print("Refresh Token: \(refreshToken)")
                        
                        let serverTokenResponse = ServerTokenResponse(accessToken: accessToken, refreshToken: refreshToken)
                        completion(serverTokenResponse)
                        moveToMain()
                    } else {
                        print("Failed to retrieve tokens from headers")
                    }

                case .failure(let error):
                    print("Failed to send token to server: \(error)")
                }
            }
    }
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

struct ServerTokenResponse {
    let accessToken: String
    let refreshToken: String
}

class LogOutManager {
    func logOut(isGoogle: Bool) {
        if isGoogle {
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
