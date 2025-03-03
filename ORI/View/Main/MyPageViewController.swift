//
//  ProfileViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class MyPageViewController: UIViewController {
    var viewModel = MyPageViewModel()
    
    lazy var myNameTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "// MY PAGE"
        label.font = UIFont.blackhansans(ofSize: 30)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myNameTextLabel)
        
        mainNavigationBar()
        
        NSLayoutConstraint.activate([
            myNameTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myNameTextLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
