//
//  NotificationCell.swift
//  ORI
//
//  Created by Song Kim on 3/21/25.
//

import UIKit

class NotificationCell: UITableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let iconImage = UIImageView(image: UIImage(systemName: "archivebox"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        subtitleLabel.textColor = .gray
        iconImage.tintColor = .baseYellow
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(iconImage)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImage.widthAnchor.constraint(equalToConstant: 25),
            iconImage.heightAnchor.constraint(equalToConstant: 25),
            
            titleLabel.centerYAnchor.constraint(equalTo: iconImage.centerYAnchor, constant: -9),
            titleLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.centerYAnchor.constraint(equalTo: iconImage.centerYAnchor, constant: 15),
            subtitleLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
