//
//  TILListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class TILListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = TILListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainNavigationBar()
        setupTableView()
        setupRefreshControl()
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        viewModel.tableView.refreshControl = refreshControl
    }

    @objc func refreshData() {
        viewModel.loadTILList()
        viewModel.tableView.refreshControl?.endRefreshing()
    }
    
    func setupTableView() {
        viewModel.loadTILList()
        viewModel.tableView.frame = view.bounds
        viewModel.tableView.dataSource = self
        viewModel.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TILPostCell")
        view.addSubview(viewModel.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TILPostCell", for: indexPath)
        let post = viewModel.posts[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }
}
