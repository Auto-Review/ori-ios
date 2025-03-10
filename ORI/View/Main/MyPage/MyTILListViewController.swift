//
//  MyTILListViewController.swift
//  ORI
//
//  Created by Song Kim on 3/10/25.
//

import UIKit

class MyTILViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var viewModel: MyPageViewModel!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.fetchData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) 
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    private func setupViewModel() {
        viewModel = MyPageViewModel()
        
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let title = viewModel.postTitle(at: indexPath.row) {
            cell.textLabel?.text = title
        }
        return cell
    }
}
