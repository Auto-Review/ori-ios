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
    
    let imageView = UIImageView(image: UIImage(named: "mainimage"))
    
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
    
    private let prevButton: UIButton = {
        let button = UIButton()
        button.setTitle("〈", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("〉", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        mainNavigationBar()
        loadDataAndUpdateUI()
        setupRefreshControl()

        view.addSubview(imageView)
        view.addSubview(calendarView)
        view.addSubview(mainpageTextLabel)
        view.addSubview(grayBackgroundView)
        view.addSubview(prevButton)
        view.addSubview(nextButton)
        view.addSubview(todayListLabel)
        
        calendarView.delegate = self
        
        prevButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            calendarView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            calendarView.heightAnchor.constraint(equalToConstant: 330),
            
            prevButton.centerYAnchor.constraint(equalTo: calendarView.topAnchor, constant: 25),
            prevButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            
            nextButton.centerYAnchor.constraint(equalTo: calendarView.topAnchor, constant: 25),
            nextButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            
            mainpageTextLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30),
            mainpageTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            grayBackgroundView.topAnchor.constraint(equalTo: mainpageTextLabel.bottomAnchor, constant: 14),
            grayBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            grayBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 130),
            
            todayListLabel.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor, constant: 10),
            todayListLabel.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 10),
            todayListLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -10)
        ])
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        loadDataAndUpdateUI()
    }
    
    private func loadDataAndUpdateUI() {
        let today = Date()
        
        viewModel.loadNotiList { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async{
                self.calendarView.select(today)
                self.calendarView.reloadData()
                
                self.viewModel.loadSelectDayAlarmList(date: today)
                self.updateTodayList()
            }
        }
    }
    
    // todayList 업데이트
    func updateTodayList() {
        let todayDates = viewModel.todayList.joined(separator: "\n")
        todayListLabel.text = todayDates
    }
    
    @objc private func prevMonth() {
        let currentPage = calendarView.currentPage
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentPage)!
        calendarView.setCurrentPage(previousMonth, animated: true)
    }
    
    @objc private func nextMonth() {
        let currentPage = calendarView.currentPage
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentPage)!
        calendarView.setCurrentPage(nextMonth, animated: true)
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
