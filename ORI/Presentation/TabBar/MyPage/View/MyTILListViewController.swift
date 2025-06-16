//
//  MyTILListViewController.swift
//  ORI
//
//  Created by Song Kim on 3/19/25.
//

import UIKit

class MyTILListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    var viewModel: MyPageViewModel
    var tableView = UITableView()
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        tableView.prefetchDataSource = self
        
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
        viewModel.loadMoreMyTILList { [weak self] in
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myTILPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostListCell()
        cell.titleLabel.text = viewModel.myTILPosts[indexPath.row].title
        cell.nameLabel.text = viewModel.myTILPosts[indexPath.row].writerNickName
        cell.dateLabel.text = viewModel.myTILPosts[indexPath.row].createdDate.prefix(10).description
        cell.reviewCntLabel.text = ""
        return cell
    }
    
    private func updateNoPostsLabelVisibility() {
        DispatchQueue.main.async {
            self.noPostsLabel.isHidden = !self.viewModel.myTILPosts.isEmpty
        }
    }
    
    private func loadDataAndUpdateUI() {
        viewModel.loadMoreMyTILList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = viewModel.myTILPosts[indexPath.row]
        fetchTILDeatilList(id: selectedPost.id) { result in
            switch result {
            case .success(let post):
                let detailVC = TILDetailViewController(post: post)
                self.navigationController?.pushViewController(detailVC, animated: true)
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension MyTILListViewController {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.myTILPosts.count - 5 == indexPath.row && !viewModel.lastTILPage {
                loadMoreData()
            }
        }
    }
    
    private func loadMoreData() {
        viewModel.loadMoreMyTILList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
            }
        }
    }
}
