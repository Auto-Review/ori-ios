//
//  LoginViewController.swift
//  ORI
//
//  Created by Song Kim on 10/8/24.
//

import UIKit
import GoogleSignIn
import Alamofire
import KeychainSwift

class LoginViewController: UIViewController {
    var viewModel = LoginViewModel()
    
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
        setupUI()
        
        disableGitHubLoginButton() // 깃허브 로그인 비활성화
    }
    
    private func disableGitHubLoginButton() {
        githubLoginButton.isEnabled = false
        githubLoginButton.alpha = 0.5
    }
    
    private func setupUI() {
        view.addSubview(githubLoginButton)
        view.addSubview(googleLoginButton)

        [githubLoginButton, googleLoginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            githubLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            githubLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            githubLoginButton.widthAnchor.constraint(equalToConstant: 200),
            githubLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            googleLoginButton.widthAnchor.constraint(equalToConstant: 200),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        githubLoginButton.addTarget(self, action: #selector(handleGitHubLogin), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
    }
    
    @objc func handleGoogleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil, let signInResult = signInResult else { return }
            let email = signInResult.user.profile?.email ?? ""
            let token = signInResult.user.idToken?.tokenString ?? ""
            self.viewModel.didReceiveUserAccessToken(token, email: email)
        }
    }
    
    @objc func handleGitHubLogin() {
        GitLoginManager.shared.requestCode()
    }
}


// GitLogin
class GitLoginManager {
    var viewModel = LoginViewModel()
    
    static let shared = GitLoginManager()
    private init() {}
    
    private let client_id = Bundle.main.infoDictionary?["GITHUB_API_KEY"] as? String ?? ""
    private let client_secret = Bundle.main.infoDictionary?["GITHUB_API_SECRET"] as? String ?? ""
    
    func requestCode() {
        let scope = "repo,user"
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(client_id)&scope=\(scope)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAccessToken(with code: String) {
        let url = "https://github.com/login/oauth/access_token"
        let parameters = ["client_id": client_id, "client_secret": client_secret, "code": code]
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers)
            .responseDecodable(of: GitHubAccessTokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    let accessToken = tokenResponse.access_token
                    KeychainSwift().set(accessToken, forKey: "accessToken")
                    self.fetchGitHubUserInfo(accessToken: accessToken)

                case .failure(let error):
                    print("Failed to request access token: \(error)")
                }
            }
    }
    
    func fetchGitHubUserInfo(accessToken: String) {
        let url = "https://api.github.com/user"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: GitHubUserResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    let email = userResponse.email ?? "No email provided"
                    self.viewModel.didReceiveUserAccessToken(accessToken, email: email)
                case .failure(let error):
                    print("Failed to get user info: \(error)")
                }
            }
    }
    func logout() {
        KeychainSwift().clear()
    }
}

struct GitHubAccessTokenResponse: Decodable {
    let access_token: String
    let token_type: String
    let scope: String
}

struct GitHubUserResponse: Decodable {
    let login: String
    let id: Int
    let email: String?
}
