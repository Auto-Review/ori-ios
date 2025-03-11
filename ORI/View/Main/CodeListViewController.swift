//
//  CodeListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class CodeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = CodeListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainNavigationBar()
        setupTableView()
        viewModel.loadCodeList()
    }
    
    func setupTableView() {
        viewModel.tableView.frame = view.bounds
        viewModel.tableView.dataSource = self
        viewModel.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        view.addSubview(viewModel.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        let post = viewModel.posts[indexPath.row]
        cell.textLabel?.text = post.title
        return cell
    }
}
