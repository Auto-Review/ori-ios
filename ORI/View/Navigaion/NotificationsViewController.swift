//
//  NotificationsViewController.swift
//  ORI
//
//  Created by Song Kim on 11/6/24.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = NotificationViewModel()
    
    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "받은 알람이 없습니다."
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
        modalNavigationBar(text: "// AL")
        
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
        return viewModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationCell()
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.subtitleLabel.text = viewModel.lists[indexPath.row].content
        cell.titleLabel.text = "REVIEW AL \(viewModel.lists[indexPath.row].executeTime.prefix(10).description)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func updateNoPostsLabelVisibility() {
        noPostsLabel.isHidden = !viewModel.lists.isEmpty
    }
    
    private func loadDataAndUpdateUI() {
        viewModel.loadNotiList() { [weak self] in
            DispatchQueue.main.async {
                self?.updateNoPostsLabelVisibility()
                self?.viewModel.tableView.reloadData()
                self?.viewModel.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}
