//
//  NotifyViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        // 키체인에서 값을 불러오는 버튼 생성
        let fetchButton = UIButton(type: .system)
        fetchButton.setTitle("Fetch Tokens", for: .normal)
        fetchButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        fetchButton.addTarget(self, action: #selector(fetchTokensFromKeychain), for: .touchUpInside)
        view.addSubview(fetchButton)
    }
    
    // 키체인에서 토큰을 불러오는 함수
    @objc func fetchTokensFromKeychain() {
        if let accessToken = KeychainManager.load(key: "accessToken"),
           let refreshToken = KeychainManager.load(key: "refreshToken") {
            print("Access Token: \(accessToken)")
            print("Refresh Token: \(refreshToken)")
        } else {
            print("Tokens not found in Keychain")
        }
    }
}
