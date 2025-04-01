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
    var todayList: [String] = []
    var tableView = UITableView()
    
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
    
    func loadAlarmList() {
        highlightedDates = notiList.map { $0.executeTime }
    }
    
    func loadSelectDayAlarmList(date: Date) {
        let date = getFormattedDate(date: date)
        todayList = notiList.filter { $0.executeTime == date }.map{ $0.content }
    }
    
    func getFormattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
