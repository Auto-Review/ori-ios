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
    let backgroundView = UIView()
    let backgroundCreateCommentView = UIView()
    
    var textViewHeightConstraint: NSLayoutConstraint?
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(UIColor.gray, for: .normal)
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
    }
    
    func addScrollView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addPostDetail() {
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(commentLabel)
        scrollView.addSubview(backgroundCreateCommentView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.borderColor = UIColor.systemGray6.cgColor
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.cornerRadius = 10
        
        backgroundCreateCommentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCreateCommentView.layer.borderColor = UIColor.systemGray6.cgColor
        backgroundCreateCommentView.layer.borderWidth = 2
        backgroundCreateCommentView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            commentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            commentLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            
            backgroundCreateCommentView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            backgroundCreateCommentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            backgroundCreateCommentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            backgroundCreateCommentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
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
        
        DispatchQueue.main.async { [self] in
            self.commentnameLabel.text = viewModel.myInfo.nickname
            let size = self.textView.sizeThatFits(CGSize(width: self.textView.frame.width, height: .greatestFiniteMagnitude))
            self.textViewHeightConstraint?.constant = size.height
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func createComment() {
        let text = commentTextView.text ?? ""
        createTILComment(comment: WriteComment(postId: post.id, body: text, isPublic: true, mentionNickName: viewModel.myInfo.nickname, mentionEmail: viewModel.myInfo.email, parentId: 1))
    }
}
