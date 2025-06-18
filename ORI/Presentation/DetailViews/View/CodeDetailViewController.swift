//
//  CodeDetailViewController.swift
//  ORI
//
//  Created by Song Kim on 5/13/25.
//

import UIKit

class CodeDetailViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate  {
    let viewModel = CodeDetailViewModel()
    var post: CodeDetail
    
    init(post: CodeDetail) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let backgroundView = UIView()
    let DateButtonView = UIView()
    let backgroundCreateCommentView = UIView()
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        return tableView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray4
        label.text = "악플, 잘못된 정보는 경고없이 삭제될 수 있습니다."
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "COMMENTS"
        return label
    }()
    
    private let commentnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("COMMIT", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.systemGray2, for: .normal)
        return button
    }()
    
    private let postTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        return label
    }()
    
    private let publicLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        return label
    }()
    
    private let codeBlock: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 5
        
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    let dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self // 슬라이드로 뒤로가기
        detailNavigationBar(text: post.title, postId: post.id, bookmarked: post.bookmarked, isCode: true)
        loadComments()
        addScrollView()
        addPostDetail()
    }
    
    private func loadComments() {
        viewModel.loadCommentList(codePostId: post.id, page: 0, size: 20) {
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
                let rowCount = self.viewModel.codePostComments.commentList.count
                let rowHeight: CGFloat = 90
                self.tableViewHeightConstraint?.constant = CGFloat(rowCount) * rowHeight
            }
        }
    }
    
    private func addScrollView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func addPostDetail() {
        let stars = starRatingView(rating: post.level)
        stars.translatesAutoresizingMaskIntoConstraints = false
        
        DateButtonView.translatesAutoresizingMaskIntoConstraints = false
        DateButtonView.layer.borderColor = UIColor.systemGray6.cgColor
        DateButtonView.layer.borderWidth = 2
        DateButtonView.layer.cornerRadius = 10
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.borderColor = UIColor.systemGray6.cgColor
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.cornerRadius = 10
        
        backgroundCreateCommentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCreateCommentView.layer.borderColor = UIColor.systemGray6.cgColor
        backgroundCreateCommentView.layer.borderWidth = 2
        backgroundCreateCommentView.layer.cornerRadius = 10
        
        contentView.addSubview(stars)
        contentView.addSubview(DateButtonView)
        contentView.addSubview(backgroundView)
        contentView.addSubview(codeBlock)
        contentView.addSubview(commentLabel)
        contentView.addSubview(backgroundCreateCommentView)
        contentView.addSubview(commentTableView)
        
        codeBlock.text = post.code
        
        NSLayoutConstraint.activate([
            stars.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stars.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            
            DateButtonView.topAnchor.constraint(equalTo: stars.bottomAnchor, constant: 12),
            DateButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            DateButtonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            backgroundView.topAnchor.constraint(equalTo: DateButtonView.bottomAnchor, constant: 12),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            codeBlock.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 12),
            codeBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            codeBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            commentLabel.topAnchor.constraint(equalTo: codeBlock.bottomAnchor, constant: 24),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            backgroundCreateCommentView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 12),
            backgroundCreateCommentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundCreateCommentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundCreateCommentView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        setDateStackView()
        setDetailPostView()
        setCreateCommentView()
        setCommentTableView()
    }
    
    private func setDateStackView() {
        DateButtonView.addSubview(dateStackView)
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: DateButtonView.topAnchor, constant: 10),
            dateStackView.leadingAnchor.constraint(equalTo: DateButtonView.leadingAnchor, constant: 16),
            dateStackView.trailingAnchor.constraint(equalTo: DateButtonView.trailingAnchor, constant: -16),
            dateStackView.bottomAnchor.constraint(equalTo: DateButtonView.bottomAnchor, constant: -10)
        ])
        
        let button = UIButton(type: .system)
        let date = DateFormat.dayTime(str: post.createDate)
        button.setTitle(date, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.contentHorizontalAlignment = .leading
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
        dateStackView.addArrangedSubview(button)
        
        if let firstButton = dateStackView.arrangedSubviews.first as? UIButton,
           let firstDate = firstButton.title(for: .normal),
           firstDate == DateFormat.dayTime(str: post.createDate) {
            
            firstButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            let attributedString = NSAttributedString(string: firstDate, attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ])
            firstButton.setAttributedTitle(attributedString, for: .normal)
        }
        
        for dto in post.dtoList {
            let button = UIButton(type: .system)
            let date = DateFormat.dayTime(str: dto.updatedAt)
            button.setTitle(date, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.contentHorizontalAlignment = .leading
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
            button.tag = dto.id
            button.addTarget(self, action: #selector(dateButtonTapped(_:)), for: .touchUpInside)
            dateStackView.addArrangedSubview(button)
        }
    }
    
    private func setDetailPostView() {
        backgroundView.addSubview(nicknameLabel)
        backgroundView.addSubview(languageLabel)
        backgroundView.addSubview(postTextView)
        backgroundView.addSubview(publicLabel)
        
        nicknameLabel.text = post.writerNickName
        languageLabel.text = post.language
        publicLabel.text = post.isPublic ? "전체공개" : "비공개"
        postTextView.text = post.description
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            
            postTextView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 2),
            postTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            postTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            languageLabel.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 2),
            languageLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            
            publicLabel.centerYAnchor.constraint(equalTo: languageLabel.centerYAnchor),
            publicLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            publicLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setCreateCommentView() {
        commentTextView.delegate = self
        
        backgroundCreateCommentView.addSubview(commentnameLabel)
        backgroundCreateCommentView.addSubview(commentTextView)
        backgroundCreateCommentView.addSubview(commentButton)
        
        NSLayoutConstraint.activate([
            commentnameLabel.topAnchor.constraint(equalTo: backgroundCreateCommentView.topAnchor, constant: 20),
            commentnameLabel.leadingAnchor.constraint(equalTo: backgroundCreateCommentView.leadingAnchor, constant: 16),
            
            commentTextView.topAnchor.constraint(equalTo: commentnameLabel.bottomAnchor, constant: 5),
            commentTextView.leadingAnchor.constraint(equalTo: backgroundCreateCommentView.leadingAnchor, constant: 16),
            commentTextView.trailingAnchor.constraint(equalTo: backgroundCreateCommentView.trailingAnchor, constant: -16),
            
            commentButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor),
            commentButton.trailingAnchor.constraint(equalTo: backgroundCreateCommentView.trailingAnchor, constant: -16),
            commentButton.bottomAnchor.constraint(equalTo: backgroundCreateCommentView.bottomAnchor, constant: -10)
        ])
        
        commentTextView.addSubview(placeHolderLabel)
        commentButton.addTarget(self, action: #selector(createComment), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: commentTextView.topAnchor, constant: 7),
            placeHolderLabel.leadingAnchor.constraint(equalTo: commentTextView.leadingAnchor),
            placeHolderLabel.trailingAnchor.constraint(equalTo: commentTextView.trailingAnchor),
        ])
    }
    
    private func setCommentTableView() {
        commentTableView.dataSource = self
        commentTableView.delegate = self
        
        tableViewHeightConstraint = commentTableView.heightAnchor.constraint(equalToConstant: 1)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: backgroundCreateCommentView.bottomAnchor, constant: 10),
            commentTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        DispatchQueue.main.async { [self] in
            self.commentnameLabel.text = viewModel.userName
        }
    }
    
    private func starRatingView(rating: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        for i in 1...5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let symbolName = i <= rating ? "starfill" : "star"
            imageView.image = UIImage(named: symbolName)
            imageView.tintColor = i <= rating ? .systemOrange : .lightGray
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            stackView.addArrangedSubview(imageView)
        }
        
        return stackView
    }
    
    @objc func dateButtonTapped(_ sender: UIButton) {
        guard let date = sender.title(for: .normal) else { return }
        
        for button in dateStackView.arrangedSubviews.compactMap({ $0 as? UIButton }) {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            let attributedString = NSAttributedString(string: button.titleLabel?.text ?? "", attributes: [
                .underlineStyle: []
            ])
            button.setAttributedTitle(attributedString, for: .normal)
        }
        
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        let attributedString = NSAttributedString(string: date, attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        sender.setAttributedTitle(attributedString, for: .normal)
        
        if DateFormat.dayTime(str: self.post.createDate) == date {
            self.codeBlock.text = self.post.code
            self.postTextView.text = self.post.description
        } else {
            fetchReviewDeatilList(id: sender.tag) { result in
                switch result {
                case .success(let list):
                    self.codeBlock.text = list.code
                    self.postTextView.text = list.description
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        DispatchQueue.main.async {
            self.placeHolderLabel.isHidden = !textView.text.isEmpty
        }
    }
    
    @objc func createComment() {
        let text = commentTextView.text ?? ""
        viewModel.createComment(text: text, postId: post.id) { success in
            if success {
                self.loadComments()
                self.commentTextView.text = ""
            }
        }
    }
}

extension CodeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.codePostComments.commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = viewModel.codePostComments.commentList[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        
        cell.onEditTapped = {
            cell.onEditCompleted = { newBody in
                self.viewModel.editComment(text: newBody, id: comment.id)
            }
        }
        
        cell.onDeleteTapped = {
            self.viewModel.deleteComment(id: comment.id) { success in
                if success {
                    self.loadComments()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
