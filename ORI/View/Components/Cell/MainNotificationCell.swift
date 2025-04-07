//
//  NotificationCell.swift
//  ORI
//
//  Created by Song Kim on 3/21/25.
//

import UIKit

class MainNotificationCell: UITableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
