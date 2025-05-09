//
//  NotificationViewModel.swift
//  ORI
//
//  Created by Song Kim on 3/21/25.
//

import UIKit

class NotificationViewModel {
    var lists: [Notification] = []
    
    func loadNotiList(completion: @escaping () -> Void) {
        fetchNotificationList(){ [weak self] result in
            switch result {
            case .success(let lists):
                self?.lists = lists
                completion()
            case .failure(let error):
                print("Error fetching posts: \(error)")
                completion()
            }
        }
    }
    
    var cellModels: [NotificationCellModel] {
        return lists.map {
            NotificationCellModel(
                title: "REVIEW AL \($0.executeTime.prefix(10))",
                subtitle: $0.content
            )
        }
    }
}
