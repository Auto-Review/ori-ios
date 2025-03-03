//
//  ProfileViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class MyPageViewController: UIViewController {
    var viewModel = MyPageViewModel()
    
    lazy var myPageMainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "// MY PAGE"
        label.font = UIFont.blackhansans(ofSize: 20)
        return label
    }()
    
    lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myPageMainTextLabel)
        view.addSubview(grayBackgroundView)
        
        mainNavigationBar()
        
        NSLayoutConstraint.activate([
            myPageMainTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            myPageMainTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            
            grayBackgroundView.topAnchor.constraint(equalTo: myPageMainTextLabel.bottomAnchor, constant: 20),
            grayBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            grayBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
}
