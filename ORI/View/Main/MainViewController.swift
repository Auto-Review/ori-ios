//
//  MainViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit

class MainViewController: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "mainimage"))
    let calendarView = UICalendarView()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    
    lazy var mainpageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "// CHEAK LIST"
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

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendar = gregorianCalendar
        
        view.addSubview(imageView)
        view.addSubview(calendarView)
        view.addSubview(mainpageTextLabel)
        view.addSubview(grayBackgroundView)
        
        mainNavigationBar()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            calendarView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            calendarView.heightAnchor.constraint(equalToConstant: 350),
            
            mainpageTextLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30),
            mainpageTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            grayBackgroundView.topAnchor.constraint(equalTo: mainpageTextLabel.bottomAnchor, constant: 14),
            grayBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            grayBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
}
