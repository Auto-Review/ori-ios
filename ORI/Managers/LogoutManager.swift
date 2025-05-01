//
//  LogoutManager.swift
//  ORI
//
//  Created by Song Kim on 3/14/25.
//

import Foundation

class LogoutManager {
    // RefreshToken 시간 만료 체크
    static func isRefreshTokenExpired() -> Bool {
        guard let expirationString = KeychainManager.load(key: "refreshTokenExpiration"),
              let expirationTimestamp = Double(expirationString) else {
            return true
        }

        let currentTimestamp = Date().timeIntervalSince1970
        return currentTimestamp >= expirationTimestamp
    }
    
    static func checkAndHandleTokenExpiration() {
        if isRefreshTokenExpired() {
            logout()
        } else {
            NavigationManager.navigateToTabView()
        }
    }
    
    static func logout() {
        KeychainManager.delete(key: "accessToken")
        KeychainManager.delete(key: "refreshToken")
        KeychainManager.delete(key: "refreshTokenExpiration")
        
        NavigationManager.navigateToLogin()
    }
}
