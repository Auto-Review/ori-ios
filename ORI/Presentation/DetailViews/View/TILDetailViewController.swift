//
//  TILDetailViewController.swift
//  ORI
//
//  Created by Song Kim on 4/14/25.
//

import UIKit

class TILDetailViewController: UIViewController, UITextViewDelegate  {
    let viewModel = TILDetailViewModel()
    var post: TIL
    
    init(post: TIL) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let backgroundView = UIView()
    let backgroundCreateCommentView = UIView()
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.separatorInset = .zero
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        return tableView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .systemGray4
        label.text = "악플, 잘못된 정보는 경고없이 삭제될 수 있습니다."
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "COMMENTS"
        return label
    }()
    
    private let commentnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("COMMIT", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(UIColor.systemGray2, for: .normal)
        return button
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailNavigationBar(text: post.title, postId: post.id)
        loadComments()
        addScrollView()
        addPostDetail()
    }
    
    private func loadComments() {
        viewModel.loadCommentList(tilPostId: post.id, page: 0, size: 20) {
            DispatchQueue.main.async {
                self.commentTableView.reloadData()
                let rowCount = self.viewModel.tilPostComments.commentList.count
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
        contentView.addSubview(backgroundView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(backgroundCreateCommentView)
        contentView.addSubview(commentTableView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.borderColor = UIColor.systemGray6.cgColor
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.cornerRadius = 10
        
        backgroundCreateCommentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCreateCommentView.layer.borderColor = UIColor.systemGray6.cgColor
        backgroundCreateCommentView.layer.borderWidth = 2
        backgroundCreateCommentView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            commentLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            backgroundCreateCommentView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            backgroundCreateCommentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backgroundCreateCommentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            backgroundCreateCommentView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        setPostDetailView()
        setCreateCommentView()
        setCommentTableView()
    }
    
    private func setPostDetailView() {
        backgroundView.addSubview(nicknameLabel)
        backgroundView.addSubview(dateLabel)
        backgroundView.addSubview(contentTextView)
        
        nicknameLabel.text = post.writerNickName
        dateLabel.text = DateFormat.dayTime(str: post.createdDate)
        contentTextView.text = post.content
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            
            dateLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 10),
            
            contentTextView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            contentTextView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15),
            contentTextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setCreateCommentView() {
        backgroundCreateCommentView.addSubview(commentnameLabel)
        backgroundCreateCommentView.addSubview(commentTextView)
        backgroundCreateCommentView.addSubview(commentButton)
        commentTextView.delegate = self
        
        NSLayoutConstraint.activate([
            commentnameLabel.topAnchor.constraint(equalTo: backgroundCreateCommentView.topAnchor, constant: 20),
            commentnameLabel.leadingAnchor.constraint(equalTo: backgroundCreateCommentView.leadingAnchor, constant: 15),
            
            commentTextView.topAnchor.constraint(equalTo: commentnameLabel.bottomAnchor, constant: 5),
            commentTextView.leadingAnchor.constraint(equalTo: backgroundCreateCommentView.leadingAnchor, constant: 15),
            commentTextView.trailingAnchor.constraint(equalTo: backgroundCreateCommentView.trailingAnchor, constant: -15),
            
            commentButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor),
            commentButton.trailingAnchor.constraint(equalTo: backgroundCreateCommentView.trailingAnchor, constant: -15),
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
            commentTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        DispatchQueue.main.async { [self] in
            self.commentnameLabel.text = viewModel.userName
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
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

extension TILDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tilPostComments.commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = viewModel.tilPostComments.commentList[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        
        cell.onEditTapped = {
            print("수정")
        }
        
        cell.onDeleteTapped = {
            if self.viewModel.userId == comment.writerId {
                deleteTILComment(commentId: comment.id, writerId: self.viewModel.userId) { success in
                    if success {
                        self.loadComments()
                    }
                }
            } else {
                print("다른사람 댓글임")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
