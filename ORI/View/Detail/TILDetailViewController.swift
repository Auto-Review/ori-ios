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
        backgroundView.layer.borderWidth = 3
        backgroundView.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        backgroundView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = dummyText
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            textView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -40)
        ])
        
        DispatchQueue.main.async {
            let size = self.textView.sizeThatFits(CGSize(width: self.textView.frame.width, height: .greatestFiniteMagnitude))
            self.textViewHeightConstraint?.constant = size.height
        }
    }
}
