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
    
    private lazy var firstTabView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondTabView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
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
        
        view.addSubview(firstTabView)
        view.addSubview(secondTabView)
        
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
            
            firstTabView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            firstTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstTabView.heightAnchor.constraint(equalToConstant: 200),
            
            secondTabView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            secondTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            secondTabView.heightAnchor.constraint(equalToConstant: 200),
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
            firstTabView.isHidden = false
            secondTabView.isHidden = true
        } else {
            firstTabView.isHidden = true
            secondTabView.isHidden = false
        }
    }
}
