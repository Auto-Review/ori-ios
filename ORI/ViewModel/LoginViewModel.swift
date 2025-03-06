//
//  LoginViewModel.swift
//  ORI
//
//  Created by Song Kim on 11/7/24.
//

import Foundation
import GoogleSignIn

class LoginViewModel {
    var idToken: String?
    var userEmail: String?
    
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
            
            self.idToken = signInResult.user.idToken?.tokenString
            self.userEmail = signInResult.user.profile?.email
            completion(true)
        }
    }
}
