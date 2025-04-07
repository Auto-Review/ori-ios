//
//  MyTabViewController.swift
//  ORI
//
//  Created by Song Kim on 3/3/25.
//

import UIKit

class MyTabViewController: UIViewController {
    var viewModel: MyPageViewModel
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        
        segment.selectedSegmentTintColor = .clear
        
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segment.insertSegment(withTitle: "MY CODE", at: 0, animated: true)
        segment.insertSegment(withTitle: "MY TIL", at: 1, animated: true)
        
        segment.selectedSegmentIndex = 0
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.blackhansans(ofSize: 20)
        ], for: .normal)
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.blackhansans(ofSize: 20)
        ], for: .selected)
        
        segment.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private lazy var underBackgroundLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leadingDistance: NSLayoutConstraint = {
        return underLineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor)
    }()
    
    private lazy var myPostListView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addChildViewController(isCode: viewModel.isCode)
    }
    
    func configure() {
        view.addSubview(containerView)
        containerView.addSubview(segmentControl)
        underBackgroundLineView.addSubview(underLineView)
        containerView.addSubview(underBackgroundLineView)
        view.addSubview(myPostListView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 25),
            
            segmentControl.topAnchor.constraint(equalTo: containerView.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            segmentControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            underLineView.bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 2),
            leadingDistance,
            underLineView.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentControl.numberOfSegments)),
            
            underBackgroundLineView.bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            underBackgroundLineView.heightAnchor.constraint(equalToConstant: 2),
            underBackgroundLineView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            myPostListView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5),
            myPostListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPostListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPostListView.heightAnchor.constraint(equalToConstant: 420),
        ])
    }
    
    @objc private func changeUnderLinePosition() {
        let segmentIndex = CGFloat(segmentControl.selectedSegmentIndex)
        let segmentWidth = segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.leadingDistance.constant = leadingDistance
            self?.view.layoutIfNeeded()
        })
        
        changeTabView()
    }
    
    private func changeTabView() {
        if segmentControl.selectedSegmentIndex == 0 {
            viewModel.isCode = true
        } else {
            viewModel.isCode = false
        }
        addChildViewController(isCode: viewModel.isCode)
    }
    
    private func addChildViewController(isCode: Bool) {
        if let currentVC = children.first {
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        let myPostVC: UIViewController
        if isCode {
            myPostVC = MyCodeListViewController(viewModel: self.viewModel)
        } else {
            myPostVC = MyTILListViewController(viewModel: self.viewModel)
        }
        
        addChild(myPostVC)
        myPostVC.view.translatesAutoresizingMaskIntoConstraints = false
        myPostVC.didMove(toParent: self)
        
        myPostListView.addSubview(myPostVC.view)
        
        NSLayoutConstraint.activate([
            myPostVC.view.topAnchor.constraint(equalTo: myPostListView.topAnchor),
            myPostVC.view.leadingAnchor.constraint(equalTo: myPostListView.leadingAnchor),
            myPostVC.view.trailingAnchor.constraint(equalTo: myPostListView.trailingAnchor),
            myPostVC.view.bottomAnchor.constraint(equalTo: myPostListView.bottomAnchor)
        ])
    }
}
