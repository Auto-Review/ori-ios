//
//  TILDetailViewController.swift
//  ORI
//
//  Created by Song Kim on 4/14/25.
//

import UIKit

class TILDetailViewController: UIViewController, UITextViewDelegate  {
    let viewModel = DetailViewModel()
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
    var textViewHeightConstraint: NSLayoutConstraint?
    
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
    
    private let textView: UITextView = {
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
        detailNavigationBar(text: post.title)
        addScrollView()
        addPostDetail()
        commentTextView.delegate = self
        
        viewModel.fetchCommentList(tilPostId: post.id, page: 0, size: 20) {
            DispatchQueue.main.async {
                self.reloadComments()
            }
        }
        
        commentTableView.dataSource = self
        commentTableView.delegate = self
    }
    
    func addScrollView() {
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
    
    func addPostDetail() {
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
        
        backgroundView.addSubview(nicknameLabel)
        backgroundView.addSubview(dateLabel)
        backgroundView.addSubview(textView)
        
        nicknameLabel.text = post.writerNickName
        dateLabel.text = DateFormat.dayTime(str: post.createdDate)
        textView.text = post.content
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            
            dateLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 10),
            
            textView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15),
            textView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20)
        ])
        
        backgroundCreateCommentView.addSubview(commentnameLabel)
        backgroundCreateCommentView.addSubview(commentTextView)
        backgroundCreateCommentView.addSubview(commentButton)
        
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
        
        tableViewHeightConstraint = commentTableView.heightAnchor.constraint(equalToConstant: 1)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: backgroundCreateCommentView.bottomAnchor, constant: 10),
            commentTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        DispatchQueue.main.async { [self] in
            self.commentnameLabel.text = viewModel.myInfo.nickname
            let size = self.textView.sizeThatFits(CGSize(width: self.textView.frame.width, height: .greatestFiniteMagnitude))
            self.textViewHeightConstraint?.constant = size.height
        }
    }
    
    func reloadComments() {
        commentTableView.reloadData()
        let rowCount = viewModel.tilPostComments.commentList.count
        let rowHeight: CGFloat = 90
        tableViewHeightConstraint?.constant = CGFloat(rowCount) * rowHeight
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func createComment() {
        let text = commentTextView.text ?? ""
        createTILComment(comment: WriteComment(
            postId: post.id,
            body: text,
            isPublic: true,
            mentionNickName: viewModel.myInfo.nickname,
            mentionEmail: viewModel.myInfo.email,
            parentId: nil
        ))
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
