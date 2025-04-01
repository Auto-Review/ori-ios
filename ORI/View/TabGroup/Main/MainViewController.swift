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
    var date = Date()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        prevButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        contentView.addSubview(imageView)
        contentView.addSubview(calendarView)
        contentView.addSubview(mainpageTextLabel)
        contentView.addSubview(grayBackgroundView)
        contentView.addSubview(prevButton)
        contentView.addSubview(nextButton)
        
        calendarView.delegate = self
        
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
            
            prevButton.centerYAnchor.constraint(equalTo: calendarView.topAnchor, constant: 25),
            prevButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
            
            nextButton.centerYAnchor.constraint(equalTo: calendarView.topAnchor, constant: 25),
            nextButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
            
            calendarView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            calendarView.heightAnchor.constraint(equalToConstant: 330),
            
            mainpageTextLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30),
            mainpageTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            
            grayBackgroundView.topAnchor.constraint(equalTo: mainpageTextLabel.bottomAnchor, constant: 14),
            grayBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            grayBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            grayBackgroundView.heightAnchor.constraint(equalToConstant: 150),
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
                self.setupCheckListTableViewController(date: self.viewModel.getFormattedDate(date: today))
            }
        }
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
    
    private func setupCheckListTableViewController(date: String) {
        let checkListVC = CheckListTableViewController(viewModel: viewModel, date: date)

        addChild(checkListVC)
        grayBackgroundView.addSubview(checkListVC.tableView)
        checkListVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkListVC.tableView.topAnchor.constraint(equalTo: grayBackgroundView.topAnchor),
            checkListVC.tableView.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor),
            checkListVC.tableView.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor),
            checkListVC.tableView.bottomAnchor.constraint(equalTo: grayBackgroundView.bottomAnchor)
        ])
        
        checkListVC.didMove(toParent: self)
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
        setupCheckListTableViewController(date: self.viewModel.getFormattedDate(date: date))
        viewModel.tableView.reloadData()
    }
}
