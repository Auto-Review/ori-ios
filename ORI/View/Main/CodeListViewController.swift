//
//  CodeListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class CodeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = CodeListViewModel()
    
    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 게시글이 없습니다."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainNavigationBar()
        setupTableView()
        setupRefreshControl()
        view.addSubview(noPostsLabel)
        
        NSLayoutConstraint.activate([
            noPostsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPostsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadDataAndUpdateUI() // 데이터 로딩 후 UI 업데이트
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        viewModel.tableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        loadDataAndUpdateUI()
    }
    
    func setupTableView() {
        viewModel.tableView.frame = view.bounds
        viewModel.tableView.dataSource = self
        viewModel.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CodePostCell")
        view.addSubview(viewModel.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodePostCell", for: indexPath)
        let post = viewModel.posts[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }
    
    private func updateNoPostsLabelVisibility() {
        noPostsLabel.isHidden = !viewModel.posts.isEmpty
    }
    
    private func loadDataAndUpdateUI() {
        viewModel.loadCodeList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.viewModel.tableView.reloadData()
                self?.viewModel.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}
