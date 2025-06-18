//
//  PostListCell.swift
//  ORI
//
//  Created by Song Kim on 3/19/25.
//

import UIKit

class PostListCell: UITableViewCell {
    let titleLabel = UILabel()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let reviewCntLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.lineBreakMode = .byTruncatingTail
        
        [nameLabel, dateLabel, reviewCntLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 10)
            $0.textColor = .gray
        }
        
        [titleLabel, nameLabel, dateLabel, reviewCntLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            dateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            
            reviewCntLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            reviewCntLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
