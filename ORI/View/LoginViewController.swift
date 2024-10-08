//
//  LoginViewController.swift
//  ORI
//
//  Created by Song Kim on 10/8/24.
//

import UIKit
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("kakao", for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = #colorLiteral(red: 0.9969366193, green: 0.8984512687, blue: 0.006965545472, alpha: 1)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(kakaoLoginButton)

        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 200),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 버튼 액션 연결
        kakaoLoginButton.addTarget(self, action: #selector(handleKakaoLogin), for: .touchUpInside)
    }

    @objc func handleKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Login with KakaoTalk succeeded.")
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Login with KakaoAccount succeeded.")
                }
            }
        }
    }
}
