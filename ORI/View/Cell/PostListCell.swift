//
//  PostListCell.swift
//  ORI
//
//  Created by Song Kim on 3/19/25.
//

import UIKit

class PostListCell: UITableViewCell {
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
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            
            reviewCntLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            reviewCntLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            reviewCntLabel.widthAnchor.constraint(equalToConstant: 40),
            
            dateLabel.centerYAnchor.constraint(equalTo: reviewCntLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: reviewCntLabel.trailingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            dateLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
