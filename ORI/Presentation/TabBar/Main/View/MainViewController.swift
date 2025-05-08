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
    var tableView = UITableView()
    var date = Date()
    
    var cellHeight: CGFloat = 0
    private var listHeightConstraint: NSLayoutConstraint?
    
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
        calendar.appearance.titleTodayColor = .black
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
    
    private let listView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "알림이 없습니다"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(listView)
        contentView.addSubview(prevButton)
        contentView.addSubview(nextButton)
        
        calendarView.delegate = self
        
        mainNavigationBar()
        setupConstraints()
        loadDataAndUpdateUI()
    }
    
    private func setupConstraints() {
        listHeightConstraint = listView.heightAnchor.constraint(equalToConstant: cellHeight)
        listHeightConstraint?.isActive = true
        
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
            
            listView.topAnchor.constraint(equalTo: mainpageTextLabel.bottomAnchor, constant: 14),
            listView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            listView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            listView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
                let dateString = DateFormat.onlyDay(date: self.date)
                self.setupCheckListTableViewController(date: dateString)
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
        listView.subviews.forEach { $0.removeFromSuperview() }

        if viewModel.selectDayTodoList.isEmpty {
            listHeightConstraint?.constant = 132
            listView.addSubview(emptyLabel)
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: listView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: listView.centerYAnchor)
            ])
        } else {
            let checkListVC = CheckListTableViewController(viewModel: viewModel, date: date)
            addChild(checkListVC)
            listView.addSubview(checkListVC.tableView)
            checkListVC.tableView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                checkListVC.tableView.topAnchor.constraint(equalTo: listView.topAnchor),
                checkListVC.tableView.leadingAnchor.constraint(equalTo: listView.leadingAnchor),
                checkListVC.tableView.trailingAnchor.constraint(equalTo: listView.trailingAnchor),
                checkListVC.tableView.bottomAnchor.constraint(equalTo: listView.bottomAnchor)
            ])

            checkListVC.didMove(toParent: self)
            listHeightConstraint?.constant = viewModel.tableViewHeight
        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

extension MainViewController {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateString = DateFormat.onlyDay(date: date)
        if viewModel.highlightedDates.contains(dateString) {
            return .baseYellow
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.loadSelectDayAlarmList(date: date)
        let dateString = DateFormat.onlyDay(date: date)
        setupCheckListTableViewController(date: dateString)

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        tableView.reloadData()
    }
}
