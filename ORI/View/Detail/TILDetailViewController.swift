//
//  TILDetailViewController.swift
//  ORI
//
//  Created by Song Kim on 4/14/25.
//

import UIKit

class TILDetailViewController: UIViewController {
    let dummyText = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent euismod, nisl at convallis luctus, magna mauris ullamcorper risus, nec suscipit nibh lorem non mauris. Nullam eget felis ut augue pretium laoreet. Aenean euismod eros non pulvinar efficitur. Donec pretium dapibus nisl, sit amet fermentum erat. Sed varius mi vel neque egestas, nec laoreet nulla tempor. Pellentesque nec odio at purus volutpat faucibus. Etiam at tellus nec sapien fermentum aliquam. Quisque pretium nibh vel gravida aliquam. Integer vel justo tortor.
    """

    let scrollView = UIScrollView()
    let backgroundView = UIView()
    let textView = UITextView()
    var textViewHeightConstraint: NSLayoutConstraint?
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Ksiomng"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "2025-04-01"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = dummyText
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
