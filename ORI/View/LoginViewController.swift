//
//  LoginViewController.swift
//  ORI
//
//  Created by Song Kim on 10/8/24.
//

import UIKit
import KakaoSDKUser
import GoogleSignIn
import NaverThirdPartyLogin
import Alamofire
import KeychainSwift

class LoginViewController: UIViewController {
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    let naverLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("네이버 로그인", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let githubLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("깃헙 로그인", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let googleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("구글 로그인", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(githubLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(naverLoginButton)
        
        githubLoginButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        naverLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            githubLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            githubLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            githubLoginButton.widthAnchor.constraint(equalToConstant: 200),
            githubLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            googleLoginButton.widthAnchor.constraint(equalToConstant: 200),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
            naverLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            naverLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            naverLoginButton.widthAnchor.constraint(equalToConstant: 200),
            naverLoginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        githubLoginButton.addTarget(self, action: #selector(handleGitHubLogin), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        naverLoginButton.addTarget(self, action: #selector(handleNaverLogin), for: .touchUpInside)
    }
    
    //깃허브 로그인
    @objc func handleGitHubLogin() {
        let client_id: String = Bundle.main.infoDictionary?["GITHUB_API_KEY"] as? String ?? ""
        print(client_id)
        let scope = "repo,user"
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(client_id)&scope=\(scope)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
    //구글 로그인
    @objc func handleGoogleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            
            let email = signInResult?.user.profile?.email ?? ""
            let token = signInResult?.user.accessToken.tokenString ?? ""
            
            print("Google 로그인 성공: \(email), \(String(describing: token))")
        }
    }
    
    //네이버 로그인
    @objc func handleNaverLogin() {
        naverLoginInstance?.requestThirdPartyLogin()
        getNaverUserInfo(accessToken: naverLoginInstance?.accessToken ?? "")
    }
}


func getNaverUserInfo(accessToken: String) {
    let url = URL(string: "https://openapi.naver.com/v1/nid/me")!
    var request = URLRequest(url: url)
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let response = json["response"] as? [String: Any] {
                let email = response["email"] as? String ?? "No email"
                
                print("Naver 로그인 성공: \(email), \(accessToken)")
            }
        } catch {
            print("JSON Parsing Error: \(error.localizedDescription)")
        }
    }
    task.resume()
}
