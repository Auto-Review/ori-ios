//
//  MyCodeListViewController.swift
//  ORI
//
//  Created by Song Kim on 3/19/25.
//

import UIKit

class MyCodeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        viewModel.loadMoreMyCodeList { [weak self] in
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CodePostCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myCodePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostListCell()
        cell.titleLabel.text = viewModel.myCodePosts[indexPath.row].title
        cell.nameLabel.text = viewModel.myCodePosts[indexPath.row].writerNickName
        cell.dateLabel.text = viewModel.myCodePosts[indexPath.row].createdDate.prefix(10).description
        cell.reviewCntLabel.text = "RE: \(viewModel.myCodePosts[indexPath.row].commentCount)"
        return cell
    }
    
    private func updateNoPostsLabelVisibility() {
        noPostsLabel.isHidden = !viewModel.myCodePosts.isEmpty
    }
    
    private func loadDataAndUpdateUI() {
        viewModel.loadMoreMyCodeList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPostId = viewModel.myCodePosts[indexPath.row].id
        fetchCodeDeatilList(id: selectedPostId) { result in
            switch result {
            case .success(let list):
                let detailVC = CodeDetailViewController(post: list)
                self.navigationController?.pushViewController(detailVC, animated: true)
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
}

extension MyCodeListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight - 100 {
            loadMoreData()
        }
    }
    
    private func loadMoreData() {
        viewModel.loadMoreMyCodeList { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.tableView.reloadData()
            }
        }
    }
}
