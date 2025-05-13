//
//  Notification.swift
//  ORI
//
//  Created by Song Kim on 3/21/25.
//

import Foundation

struct Notification: Decodable {
    let id: Int
    let codePostId: Int
    let content: String
    let executeTime: String
    let status: String
    let checked: Bool
}
