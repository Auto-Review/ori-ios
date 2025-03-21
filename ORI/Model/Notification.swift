//
//  Notification.swift
//  ORI
//
//  Created by Song Kim on 3/21/25.
//

import Foundation

struct NotificationResponse: Decodable {
    let status: String
    let data: [Notification]
    let message: String
}

struct Notification: Decodable {
    let id: Int
    let content: String
    let executeTime: String
    let status: String
    let checked: Bool
}
