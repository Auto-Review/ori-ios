//
//  NotificationViewModel.swift
//  ORI
//
//  Created by Song Kim on 3/21/25.
//

import UIKit

class NotificationViewModel {
    var lists: [Notification] = []
    let tableView = UITableView()
    
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
}
