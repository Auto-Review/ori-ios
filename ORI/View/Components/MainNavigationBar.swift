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
        
        let logoImageView = UIImageView(image: UIImage(named: "logo_b"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        let leftButton = UIBarButtonItem(customView: logoImageView)
        self.navigationItem.leftBarButtonItem = leftButton
        
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        
        let searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: boldConfig), for: .normal)
        searchButton.tintColor = .black
        
        let scrapButton = UIButton()
        scrapButton.setImage(UIImage(systemName: "archivebox", withConfiguration: boldConfig), for: .normal)
        scrapButton.tintColor = .black
        
        let notificationButton = UIButton()
        notificationButton.setImage(UIImage(systemName: "bell", withConfiguration: boldConfig), for: .normal)
        notificationButton.tintColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [searchButton, scrapButton, notificationButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        
        let rightBarButton = UIBarButtonItem(customView: stackView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        scrapButton.addTarget(self, action: #selector(scrapButtonTapped), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
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

