//
//  TokenManager.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import UIKit
import KeychainSwift

class TokenManager {
    static let shared = TokenManager()
    private let keychain = KeychainSwift()
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let expirationKey = "tokenExpiration" // 토큰 만료 시간 저장

    func saveTokens(accessToken: String, refreshToken: String, expiresIn: TimeInterval) {
        keychain.set(accessToken, forKey: accessTokenKey)
        keychain.set(refreshToken, forKey: refreshTokenKey)
        
        let expirationDate = Date().addingTimeInterval(expiresIn)
        keychain.set("\(expirationDate.timeIntervalSince1970)", forKey: expirationKey)
        
        print("✅ 토큰 저장 완료 (만료 시간: \(expirationDate))")
    }

    func getAccessToken() -> String? {
        return keychain.get(accessTokenKey)
    }

    func getRefreshToken() -> String? {
        return keychain.get(refreshTokenKey)
    }

    func isAccessTokenValid() -> Bool {
        if let expirationString = keychain.get(expirationKey),
           let expirationTime = TimeInterval(expirationString),
           Date().timeIntervalSince1970 < expirationTime {
            return true
        }
        return false
    }
}

