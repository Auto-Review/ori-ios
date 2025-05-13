//
//  MainNavigationBar.swift
//  ORI
//
//  Created by Song Kim on 2/24/25.
//

import UIKit

extension UIViewController {
    func detailNavigationBar(text: String) {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = " \(text)"
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.sizeToFit()
            return label
        }()
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        
        let closeButton: UIButton = {
            let button = UIButton()
            let icon = UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
            let resizedIcon = icon?.scaledToFitSize(CGSize(width: 12, height: 17)).withRenderingMode(.alwaysTemplate)
            button.setImage(resizedIcon, for: .normal)
            button.tintColor = .systemGray
            return button
        }()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItems = [closeItem, titleItem]
        
        let bookmarkButton: UIButton = {
            let button = UIButton()
            let icon = UIImage(systemName: "bookmark")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
            let resizedIcon = icon?.scaledToFitSize(CGSize(width: 24, height: 21)).withRenderingMode(.alwaysTemplate)
            button.setImage(resizedIcon, for: .normal)
            button.tintColor = .systemGray4
            return button
        }()
        
        let bookmarkItem = UIBarButtonItem(customView: bookmarkButton)
        navigationItem.rightBarButtonItem = bookmarkItem
    }
}
