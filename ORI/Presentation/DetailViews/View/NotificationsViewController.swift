//
//  NotificationsViewController.swift
//  ORI
//
//  Created by Song Kim on 11/6/24.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = NotificationViewModel()
    var tableView = UITableView()
    
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
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        loadDataAndUpdateUI()
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TILPostCell")
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationCell()
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        let cellModel = viewModel.cellModels[indexPath.row]
        cell.titleLabel.text = cellModel.title
        cell.subtitleLabel.text = cellModel.subtitle
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
        viewModel.loadNotiList { [weak self] in
            self?.refreshUI()
        }
    }
    
    private func refreshUI() {
        DispatchQueue.main.async {
            self.updateNoPostsLabelVisibility()
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}
