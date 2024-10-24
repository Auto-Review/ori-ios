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

private func didReceiveUserAccessToken(_ token: String, email: String) {
    print("Received Access Token: \(token)")
    print("Received Email: \(email)")
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
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(githubLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(naverLoginButton)

        [githubLoginButton, googleLoginButton, naverLoginButton].forEach {
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
            
            naverLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            naverLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            naverLoginButton.widthAnchor.constraint(equalToConstant: 200),
            naverLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        githubLoginButton.addTarget(self, action: #selector(handleGitHubLogin), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        naverLoginButton.addTarget(self, action: #selector(handleNaverLogin), for: .touchUpInside)
    }
    
    @objc func handleGoogleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil, let signInResult = signInResult else { return }
            let email = signInResult.user.profile?.email ?? ""
            let token = signInResult.user.accessToken.tokenString
            didReceiveUserAccessToken(token, email: email)
            moveToMain()
        }
    }
    
    @objc func handleNaverLogin() {
        naverLoginInstance?.requestThirdPartyLogin()
        fetchNaverUserInfo(accessToken: naverLoginInstance?.accessToken ?? "")
    }
    
    private func fetchNaverUserInfo(accessToken: String) {
        guard let url = URL(string: "https://openapi.naver.com/v1/nid/me") else { return }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let email = response["email"] as? String {
                    didReceiveUserAccessToken(accessToken, email: email)
                    moveToMain()
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    @objc func handleGitHubLogin() {
        GitLoginManager.shared.requestCode()
    }
}

class GitLoginManager {
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
                    moveToMain()

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
                    didReceiveUserAccessToken(accessToken, email: email)
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
