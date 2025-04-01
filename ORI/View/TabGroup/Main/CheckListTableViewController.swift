//
//  CheckListTableViewController.swift
//  ORI
//
//  Created by Song Kim on 4/1/25.
//

import UIKit

class CheckListTableViewController: UITableViewController {
    let viewModel: MainViewModel
    let date: String
    
    init(viewModel: MainViewModel, date: String) {
        self.viewModel = viewModel
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        viewModel.tableView.delegate = self
        viewModel.tableView.dataSource = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todayList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MainNotificationCell()
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.titleLabel.text = viewModel.todayList[indexPath.row]
        cell.subtitleLabel.text = date
        return cell
    }
}
