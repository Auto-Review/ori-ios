//
//  LoginViewController.swift
//  ORI
//
//  Created by Song Kim on 10/8/24.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    var viewModel = LoginViewModel()
    
    let oriLoginImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo_w.png")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let googleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Google 계정으로 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(googleLoginButton)
        view.addSubview(oriLoginImage)
        
        NSLayoutConstraint.activate([
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            googleLoginButton.widthAnchor.constraint(equalToConstant: 270),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
            oriLoginImage.leadingAnchor.constraint(equalTo: googleLoginButton.leadingAnchor),
            oriLoginImage.bottomAnchor.constraint(equalTo: googleLoginButton.topAnchor, constant: -10),
            oriLoginImage.widthAnchor.constraint(equalToConstant: 110),
            oriLoginImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
    }
    
    @objc func handleGoogleLogin() {
        viewModel.signInWithGoogle(presentingViewController: self) { success in
            if success {
                self.viewModel.requestTokenFromServer(idToken: self.viewModel.idToken)
                NavigationManager.navigateToTabView()
            } else {
                print("Google login failed")
            }
        }
    }
}
