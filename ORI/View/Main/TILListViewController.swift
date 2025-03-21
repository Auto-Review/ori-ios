//
//  TILListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class TILListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = TILListViewModel()
    
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
        
        loadDataAndUpdateUI()
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
        viewModel.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TILPostCell")
        view.addSubview(viewModel.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostListCell()
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.titleLabel.text = viewModel.posts[indexPath.row].title
        cell.dateLabel.text = viewModel.posts[indexPath.row].createdDate.prefix(10).description
        cell.reviewCntLabel.text = "RE: 3"
        return cell
    }
    
    private func updateNoPostsLabelVisibility() {
        noPostsLabel.isHidden = !viewModel.posts.isEmpty
    }
    
    private func loadDataAndUpdateUI() {
        viewModel.loadTILList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.viewModel.tableView.reloadData()
                self?.viewModel.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}
