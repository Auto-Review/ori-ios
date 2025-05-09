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
            
            self.requestServerToken(idToken: self.idToken) { tokenSaved in
                completion(tokenSaved)
            }
        }
    }
    
    private func requestServerToken(idToken: String, completion: @escaping (Bool) -> Void) {
        TokenNetwork.requestTokenFromServer(idToken: idToken) { tokenSaved in
            completion(tokenSaved)
        }
    }
}
