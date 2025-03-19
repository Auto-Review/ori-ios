//
//  MyViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class MyViewController: UIViewController {
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
    
    lazy var emailTextField: UITextField = createTextField(text: viewModel.myInfo.email)
    lazy var nameTextField: UITextField = createTextField(text: viewModel.myInfo.nickname)
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
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        let pencilIcon = UIImage(systemName: "pencil")
        button.setImage(pencilIcon, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myPageMainTextLabel)
        view.addSubview(grayBackgroundView)
        grayBackgroundView.addSubview(infoStackView)
        grayBackgroundView.addSubview(editButton)
        
        mainNavigationBar()
        setupConstraints()
        addMyTabView()
        
        setupViewModel()
        viewModel.fetchMyData()
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
            
            editButton.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor, constant: 20),
            editButton.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -20),
            editButton.widthAnchor.constraint(equalToConstant: 15),
            editButton.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    private func setupViewModel() {
        viewModel.didUpdateMyData = { [weak self] in
            DispatchQueue.main.async {
                self?.nameTextField.text = self!.viewModel.myInfo.nickname
                self?.emailTextField.text = self!.viewModel.myInfo.email
            }
        }
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

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal) // 텍스트 필드가 남은 공간을 차지

        return stackView
    }
    
    @objc func toggleEditMode() {
        let isEditing = emailTextField.isUserInteractionEnabled
        emailTextField.isUserInteractionEnabled.toggle()
        nameTextField.isUserInteractionEnabled.toggle()
        bioTextField.isUserInteractionEnabled.toggle()
        
        if isEditing {
            view.endEditing(true) // 키보드 닫기
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            updateMyProfile(id: viewModel.myInfo.id, nickname: nameTextField.text ?? "user")
        } else {
            editButton.setImage(UIImage(systemName: "tray.and.arrow.down.fill"), for: .normal)
        }
    }
    
    func addMyTabView() {
        let myTabVC = MyTabViewController(viewModel: viewModel)
        addChild(myTabVC)
        myTabVC.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(myTabVC.view)

        NSLayoutConstraint.activate([
            myTabVC.view.topAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor, constant: 40),
            myTabVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTabVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myTabVC.view.heightAnchor.constraint(equalToConstant: 200)
        ])

        myTabVC.didMove(toParent: self)
    }
}
