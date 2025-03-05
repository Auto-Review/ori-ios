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
        keychain.set(email, forKey: "userEmail")
        sendTokenToServer(accessToken: token) { serverTokenResponse in
            let expiresIn: TimeInterval = 3600 // 초 단위 토큰

            TokenManager.shared.saveTokens(accessToken: serverTokenResponse.accessToken,
                                           refreshToken: serverTokenResponse.refreshToken,
                                           expiresIn: expiresIn)
            print("✅ 로그인 완료! 토큰 저장")
            moveToMain()
        }
    }

    private func sendTokenToServer(accessToken: String, completion: @escaping (ServerTokenResponse) -> Void) {
        let api_url = Bundle.main.infoDictionary?["SERVER_API_URL"] as? String ?? ""
        let url = "http://\(api_url)/auth/token"
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
