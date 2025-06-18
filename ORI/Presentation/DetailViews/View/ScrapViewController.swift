//
//  ScrapViewController.swift
//  ORI
//
//  Created by Song Kim on 11/6/24.
//

import UIKit

class ScrapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    let viewModel = ScrapViewModel()
    var tableView = UITableView()
    
    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "스크랩된 게시글이 없습니다."
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        modalNavigationBar(text: "// SCRAP")
        loadDataAndUpdateUI()
        setupTableView()
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
        viewModel.loadMoreAllCodeBookMarkList { [weak self] in
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
        tableView.register(PostListCell.self, forCellReuseIdentifier: "CodeBookMarkCell")
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
        let selectedPostId = viewModel.posts[indexPath.row].codePostId
        fetchCodeDeatilList(id: selectedPostId) { result in
            switch result {
            case .success(let list):
                let detailVC = CodeDetailViewController(post: list)
                detailVC.hidesBottomBarWhenPushed = true
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    private func updateNoPostsLabelVisibility() {
        DispatchQueue.main.async {
            self.noPostsLabel.isHidden = !self.viewModel.posts.isEmpty
        }
    }
    
    private func loadDataAndUpdateUI() {
        viewModel.loadMoreAllCodeBookMarkList {
            DispatchQueue.main.async {
                self.updateNoPostsLabelVisibility()
                self.tableView.reloadData()
            }
        }
    }
}

extension ScrapViewController {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.posts.count - 5 == indexPath.row && !viewModel.lastPage {
                loadMoreData()
            }
        }
    }
    
    private func loadMoreData() {
        viewModel.loadMoreAllCodeBookMarkList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
            }
        }
    }
}
