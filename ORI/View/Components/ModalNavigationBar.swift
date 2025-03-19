//
//  ModalNavigationBar.swift
//  ORI
//
//  Created by Song Kim on 3/19/25.
//

import UIKit

extension UIViewController {
    func modalNavigationBar(text: String) {
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = text
            label.font = UIFont.blackhansans(ofSize: 25)
            return label
        }()
        navigationItem.titleView = titleLabel
        
        let closeButton = UIButton(type: .custom)
        let icon = UIImage(named: "xmark")
        let resizedIcon = icon?.scaledToFitSize(CGSize(width: 17, height: 17))
        closeButton.setImage(resizedIcon, for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: closeButton)
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
