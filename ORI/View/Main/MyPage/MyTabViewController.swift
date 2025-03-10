//
//  MyTabViewController.swift
//  ORI
//
//  Created by Song Kim on 3/3/25.
//

import UIKit

class MyTabViewController: UIViewController {
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
    
    private let myTILVC = MyTILViewController()
    
    private lazy var myCodeListView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var myTILListView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        changeTabView()
    }
    
    func configure() {
        view.addSubview(containerView)
        containerView.addSubview(segmentControl)
        underBackgroundLineView.addSubview(underLineView)
        containerView.addSubview(underBackgroundLineView)
        
        view.addSubview(myCodeListView)
        view.addSubview(myTILListView)
        addChildViewController()
        
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
            
            myCodeListView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            myCodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            myCodeListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            myCodeListView.heightAnchor.constraint(equalToConstant: 420),
            
            myTILListView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            myTILListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            myTILListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            myTILListView.heightAnchor.constraint(equalToConstant: 420),
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
            myCodeListView.isHidden = false
            myTILListView.isHidden = true
        } else {
            myCodeListView.isHidden = true
            myTILListView.isHidden = false
        }
    }
    
    private func addChildViewController() {
            addChild(myTILVC)
        myTILListView.addSubview(myTILVC.view)
            myTILVC.view.translatesAutoresizingMaskIntoConstraints = false
            myTILVC.didMove(toParent: self)

            NSLayoutConstraint.activate([
                myTILVC.view.topAnchor.constraint(equalTo: myTILListView.topAnchor),
                myTILVC.view.leadingAnchor.constraint(equalTo: myTILListView.leadingAnchor),
                myTILVC.view.trailingAnchor.constraint(equalTo: myTILListView.trailingAnchor),
                myTILVC.view.bottomAnchor.constraint(equalTo: myTILListView.bottomAnchor)
            ])
        }
}
