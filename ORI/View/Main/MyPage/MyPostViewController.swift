//
//  MyPostViewController.swift
//  ORI
//
//  Created by Song Kim on 3/10/25.
//

import UIKit

class MyPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: MyPageViewModel
    
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

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupViewModel() {
        viewModel.didUpdateData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomTableViewCell()
        
        if let title = viewModel.postTitle(at: indexPath.row) {
            cell.titleLabel.text = title
        }

        if let date = viewModel.postDate(at: indexPath.row) {
            cell.dateLabel.text = date
        }
        cell.reviewCntLabel.text = "RE: 3"
        
        return cell
    }
}

class CustomTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let reviewCntLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        reviewCntLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.textColor = .gray
        reviewCntLabel.textColor = .gray
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(reviewCntLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewCntLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            reviewCntLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            reviewCntLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            
            dateLabel.centerYAnchor.constraint(equalTo: reviewCntLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: reviewCntLabel.trailingAnchor, constant: 30),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
