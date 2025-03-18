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
        
        // 키체인에서 값을 불러오는 버튼 생성
        let fetchButton = UIButton(type: .system)
        fetchButton.setTitle("Fetch Tokens", for: .normal)
        fetchButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        fetchButton.addTarget(self, action: #selector(fetchTokensFromKeychain), for: .touchUpInside)
        view.addSubview(fetchButton)
        
        let reissued = UIButton(type: .system)
        reissued.setTitle("reissued", for: .normal)
        reissued.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        reissued.addTarget(self, action: #selector(reissuedKeychain), for: .touchUpInside)
        view.addSubview(reissued)
        
        let logout = UIButton(type: .system)
        logout.setTitle("logout", for: .normal)
        logout.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        logout.addTarget(self, action: #selector(logoutk), for: .touchUpInside)
        view.addSubview(logout)
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
    
    @objc func reissuedKeychain() {
        if let accessToken = KeychainManager.load(key: "accessToken") {
           TokenNetwork.reissuedTokenFromServer()
            print("성공 \(accessToken)")
        } else {
            print("Tokens not found in Keychain")
        }
    }
    
    @objc func logoutk() {
        LogoutManager.logout()
    }
}
