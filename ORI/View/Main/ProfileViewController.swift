//
//  ProfileViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewModel = ProfileViewModel()
    
    let profileContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = UIColor.oriyellow
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        return tableView
    }()
    
    let settingItems = [
        ("계정", "person"),
        ("화면", "ipad.and.iphone"),
        ("알림", "bell"),
        ("문의", "questionmark.circle"),
        ("로그아웃", "power")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        
        usernameLabel.text = viewModel.user.name
        emailLabel.text = viewModel.user.email
        
        setupProfileView()
        setupSettingsTableView()
    }
    
    func setupProfileView() {
        view.addSubview(profileContainerView)
        profileContainerView.addSubview(profileImageView)
        profileContainerView.addSubview(usernameLabel)
        profileContainerView.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileContainerView.heightAnchor.constraint(equalToConstant: 110),
            
            profileImageView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: profileContainerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 25),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
        ])
    }
    
    func setupSettingsTableView() {
        view.addSubview(settingsTableView)
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.layer.cornerRadius = 10
        settingsTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: 20),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsTableView.heightAnchor.constraint(equalToConstant: 225)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        let item = settingItems[indexPath.row]
        cell.textLabel?.text = item.0
        cell.imageView?.image = UIImage(systemName: item.1)
        cell.imageView?.tintColor = .systemYellow
        
        cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.imageView!.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),
            cell.imageView!.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.imageView!.widthAnchor.constraint(equalToConstant: 19),
            cell.imageView!.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.textLabel!.leadingAnchor.constraint(equalTo: cell.imageView!.trailingAnchor, constant: 8),
            cell.textLabel!.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = settingItems[indexPath.row]
        print("Item tapped: \(selectedItem.0)")
    }
}
