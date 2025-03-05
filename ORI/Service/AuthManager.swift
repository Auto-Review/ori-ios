//
//  AuthManager.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import UIKit
import GoogleSignIn
import KeychainSwift
import Alamofire

class AuthManager {
    let keychain = KeychainSwift()
    
    func checkLoginStatus() {
        if TokenManager.shared.isAccessTokenValid() {
            print("✅ Access Token 유효, 자동 로그인 성공!")
            moveToMain()
        } else if let refreshToken = TokenManager.shared.getRefreshToken() {
            print("🔄 Access Token 만료, Refresh Token으로 갱신 시도")
            refreshAccessToken(refreshToken: refreshToken)
        } else {
            print("❌ 토큰 없음, 로그인 필요")
            moveToLogin()
        }
    }
    
    private func refreshAccessToken(refreshToken: String) {
        let api_url = Bundle.main.infoDictionary?["SERVER_API_URL"] as? String ?? ""
        let url = "http://\(api_url)v1/api/auth/refresh"
        let parameters: [String: String] = ["refreshToken": refreshToken]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any],
                       let newAccessToken = json["accessToken"] as? String,
                       let newRefreshToken = json["refreshToken"] as? String,
                       let expiresIn = json["expiresIn"] as? TimeInterval {
                        print("✅ 토큰 갱신 성공!")
                        TokenManager.shared.saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken, expiresIn: expiresIn)
                        moveToMain()
                    } else {
                        print("❌ Refresh Token 만료, 로그인 필요")
                        moveToLogin()
                    }
                    
                case .failure(let error):
                    print("❌ 토큰 갱신 실패: \(error)")
                    moveToLogin()
                }
            }
    }
}

func moveToLogin() {
    GIDSignIn.sharedInstance.signOut()
    
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

