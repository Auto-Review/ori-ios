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
        
        // 알림 목록을 불러오는 버튼 추가
        let fetchNotificationsButton = UIButton(type: .system)
        fetchNotificationsButton.setTitle("Fetch Notifications", for: .normal)
        fetchNotificationsButton.frame = CGRect(x: 100, y: 400, width: 200, height: 50)
        fetchNotificationsButton.addTarget(self, action: #selector(fetchNotifications), for: .touchUpInside)
        view.addSubview(fetchNotificationsButton)
        
        // 기타 버튼들
        let reissued = UIButton(type: .system)
        reissued.setTitle("Reissue Token", for: .normal)
        reissued.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        reissued.addTarget(self, action: #selector(reissuedKeychain), for: .touchUpInside)
        view.addSubview(reissued)
        
        let logout = UIButton(type: .system)
        logout.setTitle("Logout", for: .normal)
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
    
    // 알림 목록을 불러오는 함수
    @objc func fetchNotifications() {
        fetchNotificationList { result in
            switch result {
            case .success(let notifications):
                print("Fetched notifications: \(notifications)")
            case .failure(let error):
                print("Failed to fetch notifications: \(error.localizedDescription)")
            }
        }
    }
    
    // 토큰 재발급 함수
    @objc func reissuedKeychain() {
        TokenNetwork.reissuedTokenFromServer()
    }
    
    // 로그아웃 함수
    @objc func logoutk() {
        LogoutManager.logout()
    }
}
