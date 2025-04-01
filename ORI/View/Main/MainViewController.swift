//
//  MainViewController.swift
//  ORI
//
//  Created by Song Kim on 10/5/24.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance {
    let viewModel = MainViewModel()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "mainimage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.placeholderType = .none
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.todayColor = .clear
        calendar.appearance.selectionColor = .baseYellow
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .gray
        calendar.weekdayHeight = 55
        calendar.appearance.titleFont = UIFont.kopubBold(ofSize: 15)
        calendar.appearance.weekdayFont = UIFont.kopubBold(ofSize: 14)
        calendar.appearance.headerTitleFont = UIFont.kopubBold(ofSize: 15)
        return calendar
    }()
    
    lazy var mainpageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "// CHECK LIST"
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
    
    lazy var todayListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(calendarView)
        contentView.addSubview(mainpageTextLabel)
        contentView.addSubview(grayBackgroundView)
        contentView.addSubview(todayListLabel)
        
        mainNavigationBar()
        setupConstraints()
        loadDataAndUpdateUI()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            
            calendarView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            calendarView.heightAnchor.constraint(equalToConstant: 330),
            
            mainpageTextLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30),
            mainpageTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            
            grayBackgroundView.topAnchor.constraint(equalTo: mainpageTextLabel.bottomAnchor, constant: 14),
            grayBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            grayBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 500),
            
            todayListLabel.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor, constant: 10),
            todayListLabel.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 10),
            todayListLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -10),
            todayListLabel.bottomAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor, constant: -10),
            
            grayBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadDataAndUpdateUI() {
        let today = Date()
        
        viewModel.loadNotiList { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.calendarView.select(today)
                self.calendarView.reloadData()
                
                self.viewModel.loadSelectDayAlarmList(date: today)
                self.updateTodayList()
            }
        }
    }
    
    func updateTodayList() {
        let todayDates = viewModel.todayList.joined(separator: "\n")
        todayListLabel.text = todayDates
    }
}

extension MainViewController {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if viewModel.highlightedDates.contains(dateString) {
            return .baseYellow
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.loadSelectDayAlarmList(date: date)
        updateTodayList()
    }
}
