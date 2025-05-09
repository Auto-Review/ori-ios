//
//  TILListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class TILListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = TILListViewModel()
    var tableView = UITableView()
    
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
        tableView.rowHeight = 70
        
        mainNavigationBar()
        setupTableView()
        loadDataAndUpdateUI()
        setupRefreshControl()
        
        view.addSubview(noPostsLabel)
        NSLayoutConstraint.activate([
            noPostsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPostsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        viewModel.resetMyCodeList()
        viewModel.fetchMoreAllTILList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TILPostCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostListCell()
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        
        let cellModel = viewModel.cellModels[indexPath.row]
        cell.titleLabel.text = cellModel.title
        cell.nameLabel.text = cellModel.author
        cell.dateLabel.text = cellModel.date
        cell.reviewCntLabel.text = cellModel.reviewCountText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = viewModel.posts[indexPath.row]
        let detailVC = TILDetailViewController(post: selectedPost)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func updateNoPostsLabelVisibility() {
        noPostsLabel.isHidden = !viewModel.posts.isEmpty
    }
    
    private func loadDataAndUpdateUI() {
        viewModel.fetchMoreAllTILList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
            }
        }
    }
}

extension TILListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 100 {
            loadMoreData()
        }
    }
    
    private func loadMoreData() {
        viewModel.fetchMoreAllTILList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
                
            }
        }
    }
}
