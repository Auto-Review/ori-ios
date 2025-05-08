//
//  MainViewModel.swift
//  ORI
//
//  Created by Song Kim on 4/1/25.
//

import UIKit

class MainViewModel {
    var notiList: [Notification] = []
    var highlightedDates: [String] = []
    var selectDayTodoList: [String] = []
    
    func loadNotiList(completion: @escaping () -> Void) {
        fetchNotificationList() { [weak self] result in
            switch result {
            case .success(let lists):
                self?.notiList = lists
                self?.loadAlarmList()
                completion()
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    var tableViewHeight: CGFloat {
        return CGFloat(selectDayTodoList.count * 44)
    }
    
    func loadAlarmList() {
        highlightedDates = notiList.map { $0.executeTime }
    }
    
    func loadSelectDayAlarmList(date: Date) {
        let date = DateFormat.onlyDay(date: date)
        selectDayTodoList = notiList.filter { $0.executeTime == date }.map{ $0.content }
    }
}
