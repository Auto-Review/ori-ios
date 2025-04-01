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
    
    func loadNotiList(completion: @escaping () -> Void) {
        fetchNotificationList() { [weak self] result in
            switch result {
            case .success(let lists):
                self?.notiList = lists
                self?.loadAlarmList()
                completion()  // 데이터 로딩 완료 후 completion 호출
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    func loadAlarmList() {
        highlightedDates = notiList.map { $0.executeTime }
        print("Highlighted Dates: \(highlightedDates)")
    }
}
