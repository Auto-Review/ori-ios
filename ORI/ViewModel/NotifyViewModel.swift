//
//  NotifyViewModel.swift
//  ORI
//
//  Created by Song Kim on 2/16/25.
//

import UIKit

class NotifyViewModel {
    struct Alarm {
        let title: String
        let date: String
    }
    
    private(set) var alarms: [Alarm] = [
        Alarm(title: "복습 알림 - Title", date: "2024.01.01"),
        Alarm(title: "복습 알림 - Title", date: "2024.01.01"),
        Alarm(title: "복습 알림 - Title", date: "2024.01.01")
    ]
}
