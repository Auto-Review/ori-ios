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
        fetchNotificationsButton.setTitle("comment", for: .normal)
        fetchNotificationsButton.frame = CGRect(x: 100, y: 400, width: 200, height: 50)
        fetchNotificationsButton.addTarget(self, action: #selector(fetchNotifications), for: .touchUpInside)
        view.addSubview(fetchNotificationsButton)
        
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
    
    @objc func fetchNotifications() {
        createTILComment(comment: WriteComment(postId: 11, body: "에헤이", isPublic: true, mentionNickName: "ksiomng", mentionEmail: "nadana092@gmail.com", parentId: 1))
    }
    
    // 로그아웃 함수
    @objc func logoutk() {
        LogoutManager.logout()
    }
}
