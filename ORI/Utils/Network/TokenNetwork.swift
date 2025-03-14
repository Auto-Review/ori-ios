//
//  TokenNetwork.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import Alamofire
import Foundation

class TokenNetwork {
    static func requestTokenFromServer(idToken: String) {
        let url = "http://\(NetworkConstants.baseURL)/auth/token"
        let parameters: [String: String] = ["accessToken": idToken]
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
                        print("Access Token: \(accessToken)")
                        print("Refresh Token: \(refreshToken)")
                        
                        // 리프레시 토큰 만료시간 저장
                        let expiresIn: TimeInterval = 21600
                        let expirationDate = Date().addingTimeInterval(expiresIn)
                        let expirationTimestamp = expirationDate.timeIntervalSince1970
                        
                        if KeychainManager.save("accessToken", accessToken) && KeychainManager.save("refreshToken", refreshToken) && KeychainManager.save("refreshTokenExpiration", "\(expirationTimestamp)") {
                            print("키체인 저장완료")
                        }
                    } else {
                        print("Failed to retrieve tokens from headers")
                    }
                    
                case .failure(let error):
                    print("Failed to send token to server: \(error)")
                }
            }
    }
}
