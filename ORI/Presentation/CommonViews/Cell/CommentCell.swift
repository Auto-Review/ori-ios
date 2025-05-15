//
//  CommentCell.swift
//  ORI
//
//  Created by Song Kim on 4/30/25.
//


import UIKit

class CommentCell: UITableViewCell {
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .gray
        button.showsMenuAsPrimaryAction = true // 메뉴가 버튼 클릭 시 바로 표시됨
        return button
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    private let containerStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        selectionStyle = .none
        
        let topRow = UIStackView(arrangedSubviews: [nicknameLabel, UIView(), moreButton])
        topRow.axis = .horizontal
        topRow.alignment = .center
        
        containerStackView.axis = .vertical
        containerStackView.spacing = 6
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(topRow)
        containerStackView.addArrangedSubview(bodyLabel)
        containerStackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupMenu() {
        let edit = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] _ in
            self?.onEditTapped?()
        }
        let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.onDeleteTapped?()
        }
        moreButton.menu = UIMenu(title: "", children: [edit, delete])
    }
    
    func configure(with comment: Comment) {
        nicknameLabel.text = comment.writerNickName
        bodyLabel.text = comment.body
        dateLabel.text = DateFormat.dayTime(str: comment.updatedAt)
    }
}
