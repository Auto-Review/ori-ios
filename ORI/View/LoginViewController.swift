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
        LoginManager.shared.requestCode()
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

// GitHub API 경로 설정
enum ApiPath: String {
    case LOGIN = "/login/oauth/authorize" // 사용자의 GitHub 아이디 인증
    case ACCESS_TOKEN = "/login/oauth/access_token" // Access token 요청
    case USER = "/user" // 사용자 정보 요청
    case REPOS = "/user/repos" // 사용자 레포지토리 정보
}

// GitHub 로그인 관리 클래스
class LoginManager {
    
    static let shared = LoginManager()
    
    private let client_id: String = ""
    private let client_secret: String = "" // 깃허브 애플리케이션의 클라이언트 시크릿
    private let scope: String = "repo gist user"
    private let githubURL: String = "https://github.com"
    private let githubApiURL: String = "https://api.github.com"
    private let redirectURI: String = "ori://github-callback" // GitHub에 설정한 redirect URI
    
    // GitHub 로그인을 위한 코드 요청
    func requestCode() {
        var components = URLComponents(string: githubURL + ApiPath.LOGIN.rawValue)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.client_id),
            URLQueryItem(name: "scope", value: self.scope),
            URLQueryItem(name: "redirect_uri", value: redirectURI)
        ]
        let urlString = components.url?.absoluteString
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // 엑세스 토큰 요청
    func requestAccessToken(with code: String) {
        let parameters = ["client_id": client_id,
                          "client_secret": client_secret,
                          "code": code]
        
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(githubURL+ApiPath.ACCESS_TOKEN.rawValue,
                   method: .post, parameters: parameters,
                   headers: headers).responseJSON { (response) in
            switch response.result {
            case let .success(json):
                if let dic = json as? [String: String] {
                    let accessToken = dic["access_token"] ?? ""
                    KeychainSwift().set(accessToken, forKey: "accessToken")
                    
                    // 엑세스 토큰 출력 후 사용자 정보 요청
                    print("Access Token: \(accessToken)")
                    self.getUser()  // 사용자 정보 가져오기
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // 사용자 정보 가져오기
    func getUser() {
        let accessToken = KeychainSwift().get("accessToken") ?? ""
        let headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json",
                                    "Authorization": "token \(accessToken)"]
        
        AF.request(githubApiURL+ApiPath.USER.rawValue,
                   method: .get,
                   parameters: [:],
                   headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let json):
                if let userData = json as? [String: Any],
                   let email = userData["email"] as? String {
                    // 성공 시 이메일 출력
                    print("GitHub 로그인 성공: \(email), \(accessToken)")
                } else {
                    print("GitHub 로그인 성공: 이메일 정보 없음, Access Token: \(accessToken)")
                }
            case .failure(let error):
                print("GitHub 사용자 정보 요청 실패: \(error.localizedDescription)")
            }
        })
    }
}
