//
//  ProfileViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class MyPageViewController: UIViewController {
    var viewModel = MyPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        
        mainNavigationBar()
        
    }
}
