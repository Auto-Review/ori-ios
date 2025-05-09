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
    
    var numberOfTodos: Int {
        return selectDayTodoList.count
    }
    
    func loadAlarmList() {
        highlightedDates = notiList.map { $0.executeTime }
    }
    
    func loadSelectDayAlarmList(date: Date) {
        let date = DateFormat.onlyDay(date: date)
        selectDayTodoList = notiList.filter { $0.executeTime == date }.map{ $0.content }
    }
    
    func loadDataAndUpdateUI(today: Date, completion: @escaping (_ todos: [String], _ dateString: String) -> Void) {
        loadNotiList { [weak self] in
            guard let self = self else { return }
            self.loadSelectDayAlarmList(date: today)
            let dateString = DateFormat.onlyDay(date: today)
            completion(self.selectDayTodoList, dateString)
        }
    }
}
