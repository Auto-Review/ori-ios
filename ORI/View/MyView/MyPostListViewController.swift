//
//  MyPostListViewController.swift
//  ORI
//
//  Created by Song Kim on 3/10/25.
//

import UIKit

class MyPostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: MyPageViewModel
    
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
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.addSubview(noPostsLabel)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noPostsLabel.topAnchor.constraint(equalTo: view.topAnchor),
            noPostsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noPostsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noPostsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        updateNoPostsLabelVisibility()
    }

    private func setupViewModel() {
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateNoPostsLabelVisibility()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostListCell()
        
        if let title = viewModel.postTitle(at: indexPath.row) {
            cell.titleLabel.text = title
        }

        if let date = viewModel.postDate(at: indexPath.row) {
            cell.dateLabel.text = date
        }
        cell.reviewCntLabel.text = "RE: 3"
        
        return cell
    }
    
    private func updateNoPostsLabelVisibility() {
        noPostsLabel.isHidden = viewModel.numberOfPosts() > 0
    }
}
