//
//  MainNavigationBar.swift
//  ORI
//
//  Created by Song Kim on 2/24/25.
//

import UIKit

extension UIViewController {
    func mainNavigationBar() {
        self.navigationItem.titleView = nil

        let leftButton = UIBarButtonItem(image: UIImage(named: "logo_b"), style: .plain, target: self, action: nil)
        leftButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = leftButton

        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let scrapButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(scrapButtonTapped))
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationButtonTapped))

        searchButton.tintColor = .black
        scrapButton.tintColor = .black
        notificationButton.tintColor = .black

        self.navigationItem.rightBarButtonItems = [notificationButton, scrapButton, searchButton]
    }

    @objc func searchButtonTapped() {
        print("검색 버튼 클릭됨")
    }

    @objc func scrapButtonTapped() {
        print("스크랩 버튼 클릭됨")
    }

    @objc func notificationButtonTapped() {
        print("알림 버튼 클릭됨")
    }
}
