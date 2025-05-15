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
    var onEditCompleted: ((String) -> Void)? // 수정 완료 시 콜백
    
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
        textField.isUserInteractionEnabled = false // 초기에는 비활성화
        return textField
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.isHidden = true // 처음엔 숨김
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
        
        let topRow = UIStackView(arrangedSubviews: [nicknameLabel, UIView(), moreButton])
        topRow.axis = .horizontal
        topRow.alignment = .center
        
        let bodyRow = UIStackView(arrangedSubviews: [bodyTextField, completeButton])
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
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            completeButton.widthAnchor.constraint(equalToConstant: 50)
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
        completeButton.isHidden = false
    }
    
    @objc private func didTapComplete() {
        bodyTextField.isUserInteractionEnabled = false
        completeButton.isHidden = true
        bodyTextField.resignFirstResponder()
        onEditCompleted?(bodyTextField.text ?? "")
    }
    
    func configure(with comment: Comment) {
        nicknameLabel.text = comment.writerNickName
        bodyTextField.text = comment.body
        dateLabel.text = DateFormat.dayTime(str: comment.updatedAt)
    }
}
