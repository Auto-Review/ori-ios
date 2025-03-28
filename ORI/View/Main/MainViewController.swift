//
//  MainViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class MainViewController: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "mainimage"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
        mainNavigationBar()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
