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
    
    func loadNotiList(completion: @escaping () -> Void) {
        fetchNotificationList() { [weak self] result in
            switch result {
            case .success(let lists):
                self?.notiList = lists
                self?.loadAlarmList()
                self?.loadTodayAlarmList()
                completion()
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    func loadAlarmList() {
        highlightedDates = notiList.map { $0.executeTime }
        print("Highlighted Dates: \(highlightedDates)")
    }
    
    func loadTodayAlarmList() {
        let today = getFormattedCurrentDate()
        todayList = notiList.filter { $0.executeTime == today }.map{ $0.content }
        print("오늘꺼 : \(todayList)")
    }
    
    func getFormattedCurrentDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: currentDate)
    }
}
