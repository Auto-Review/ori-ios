//
//  CommentCell.swift
//  ORI
//
//  Created by Song Kim on 4/30/25.
//


import UIKit

class CommentCell: UITableViewCell {
    let userId = UserDefaultsManager.shared.userId
    
    var onEditTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    var onEditCompleted: ((String) -> Void)?
    
    private let actionButtonContainer = UIView()
    
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
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private let bodyTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = .darkGray
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.isHidden = true
        return button
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
        completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        selectionStyle = .none
        
        actionButtonContainer.addSubview(moreButton)
        actionButtonContainer.addSubview(completeButton)
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: actionButtonContainer.topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: actionButtonContainer.trailingAnchor),
            moreButton.bottomAnchor.constraint(equalTo: actionButtonContainer.bottomAnchor),

            completeButton.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor),
        ])
        
        let topRow = UIStackView(arrangedSubviews: [nicknameLabel, UIView(), actionButtonContainer])
        topRow.axis = .horizontal
        topRow.alignment = .center
        
        let bodyRow = UIStackView(arrangedSubviews: [bodyTextField])
        bodyRow.axis = .horizontal
        bodyRow.spacing = 8
        bodyRow.alignment = .center
        
        containerStackView.axis = .vertical
        containerStackView.spacing = 6
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(topRow)
        containerStackView.addArrangedSubview(bodyRow)
        containerStackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupMenu() {
        let edit = UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] _ in
            self?.enableEditing()
            self?.onEditTapped?()
        }
        let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.onDeleteTapped?()
        }
        moreButton.menu = UIMenu(title: "", children: [edit, delete])
    }
    
    private func enableEditing() {
        bodyTextField.isUserInteractionEnabled = true
        bodyTextField.becomeFirstResponder()
        moreButton.isHidden = true
        completeButton.isHidden = false
    }

    @objc private func didTapComplete() {
        bodyTextField.isUserInteractionEnabled = false
        bodyTextField.resignFirstResponder()
        moreButton.isHidden = false
        completeButton.isHidden = true
        onEditCompleted?(bodyTextField.text ?? "")
    }
    
    func configure(with comment: Comment) {
        nicknameLabel.text = comment.writerNickName
        bodyTextField.text = comment.body
        dateLabel.text = DateFormat.dayTime(str: comment.updatedAt)
        
        let isOwnComment = (comment.writerId == self.userId)
        moreButton.isHidden = !isOwnComment
    }
}
