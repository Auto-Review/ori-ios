//
//  TILListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class CustomTILCell: UITableViewCell {
    let titleLabel = UILabel()
    let createdTimeLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, createdTimeLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        createdTimeLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0 // 여러 줄 표시 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TILListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel = TILListViewModel()
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(CustomTILCell.self, forCellReuseIdentifier: "TILCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TILCell", for: indexPath) as? CustomTILCell else {
            return UITableViewCell()
        }
        
        if let post = viewModel.getPost(at: indexPath.row) {
            cell.titleLabel.text = post.title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            cell.createdTimeLabel.text = dateFormatter.string(from: post.createdTime)
            cell.descriptionLabel.text = post.description
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // 셀 선택 시 행동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
