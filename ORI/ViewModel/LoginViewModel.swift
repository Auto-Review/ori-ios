//
//  LoginViewModel.swift
//  ORI
//
//  Created by Song Kim on 11/7/24.
//

import Foundation
import GoogleSignIn
import Alamofire
import KeychainSwift

class LoginViewModel {
    var idToken: String = ""
    var userEmail: String = ""
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard error == nil else {
                completion(false)
                return
            }
            
            guard let signInResult = signInResult else {
                completion(false)
                return
            }
            
            self.idToken = signInResult.user.idToken!.tokenString
            self.userEmail = signInResult.user.profile!.email
            completion(true)
        }
    }
    
    
    func requestTokenFromServer(idToken: String) {
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
                        if KeychainManager.save("accessToken", accessToken) && KeychainManager.save("refreshToken", refreshToken) {
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
