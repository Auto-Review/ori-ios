//
//  ProfileViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class MyPageViewController: UIViewController {
    var viewModel = MyPageViewModel()
    
    lazy var myPageMainTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "// MY PAGE"
        label.font = UIFont.blackhansans(ofSize: 20)
        return label
    }()
    
    lazy var grayBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var emailLabel: UILabel = createLabel(text: "Email")
    lazy var nameLabel: UILabel = createLabel(text: "Name")
    lazy var bioLabel: UILabel = createLabel(text: "Bio")
    
    lazy var emailTextField: UITextField = createTextField(text: "laplaya1411@gmail.com")
    lazy var nameTextField: UITextField = createTextField(text: "치킨")
    lazy var bioTextField: UITextField = createTextField(text: "4월 20일까지 모든 것을 끝냅시다!")

    lazy var emailStackView: UIStackView = createStackView(label: emailLabel, textField: emailTextField)
    lazy var nameStackView: UIStackView = createStackView(label: nameLabel, textField: nameTextField)
    lazy var bioStackView: UIStackView = createStackView(label: bioLabel, textField: bioTextField)
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailStackView, nameStackView, bioStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myPageMainTextLabel)
        view.addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(infoStackView)
        
        mainNavigationBar()
        setupConstraints()
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }
    
    func createTextField(text: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = false
        return textField
    }
    
    func createStackView(label: UILabel, textField: UITextField) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            myPageMainTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            myPageMainTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            
            grayBackgroundView.topAnchor.constraint(equalTo: myPageMainTextLabel.bottomAnchor, constant: 14),
            grayBackgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            grayBackgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 130),
            
            infoStackView.centerXAnchor.constraint(equalTo: grayBackgroundView.centerXAnchor),
            infoStackView.centerYAnchor.constraint(equalTo: grayBackgroundView.centerYAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -20),
            
            emailTextField.widthAnchor.constraint(equalToConstant: 260),
            nameTextField.widthAnchor.constraint(equalToConstant: 260),
            bioTextField.widthAnchor.constraint(equalToConstant: 260)
        ])
    }
}
