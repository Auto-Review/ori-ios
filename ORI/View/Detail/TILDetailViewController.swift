//
//  TILDetailViewController.swift
//  ORI
//
//  Created by Song Kim on 4/14/25.
//

import UIKit

class TILDetailViewController: UIViewController {
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
    let textView = UITextView()
    var textViewHeightConstraint: NSLayoutConstraint?
    
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
        navigationItem.title = post.title
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.borderColor = UIColor.systemGray6.cgColor
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        backgroundView.addSubview(textView)
        backgroundView.addSubview(nicknameLabel)
        backgroundView.addSubview(dateLabel)
        nicknameLabel.text = post.writerNickName
        dateLabel.text = DateFormat.dayTime(str: post.createdDate)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = post.content
        textView.textContainer.lineFragmentPadding = 0
        
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
        
        DispatchQueue.main.async {
            let size = self.textView.sizeThatFits(CGSize(width: self.textView.frame.width, height: .greatestFiniteMagnitude))
            self.textViewHeightConstraint?.constant = size.height
        }
    }
}
