//
//  CodeListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import Foundation

class CodeListViewModel {
    var data: [CodePost] = [
        CodePost(title: "Swift Basics", member_id: 1001, level: 3, timer: "00:30", code: "SWIFT101", description: "Introduction to Swift programming fundamentals.", images: [101: "image1.jpg"], createdTime: Date(), reviewTime: "01:00"),
        CodePost(title: "Swift Basics", member_id: 1001, level: 3, timer: "00:30", code: "SWIFT101", description: "Introduction to Swift programming fundamentals.", images: [101: "image1.jpg"], createdTime: Date(), reviewTime: "01:00"),
        CodePost(title: "Working with JSON", member_id: 1008, level: 1, timer: "00:50", code: "JSON301", description: "Parsing JSON data in Swift applications.", images: [108: "image8.jpg"], createdTime: Date(), reviewTime: "01:20"),
        CodePost(title: "Animations in UIKit", member_id: 1009, level: 2, timer: "00:55", code: "ANIM401", description: "Creating smooth animations in UIKit.", images: [109: "image9.jpg"], createdTime: Date(), reviewTime: "01:25"),        
        CodePost(title: "Swift Basics", member_id: 1001, level: 3, timer: "00:30", code: "SWIFT101", description: "Introduction to Swift programming fundamentals.", images: [101: "image1.jpg"], createdTime: Date(), reviewTime: "01:00"),
        CodePost(title: "Swift Basics", member_id: 1001, level: 3, timer: "00:30", code: "SWIFT101", description: "Introduction to Swift programming fundamentals.", images: [101: "image1.jpg"], createdTime: Date(), reviewTime: "01:00"),
        CodePost(title: "Working with JSON", member_id: 1008, level: 1, timer: "00:50", code: "JSON301", description: "Parsing JSON data in Swift applications.", images: [108: "image8.jpg"], createdTime: Date(), reviewTime: "01:20"),
        CodePost(title: "Animations in UIKit", member_id: 1009, level: 2, timer: "00:55", code: "ANIM401", description: "Creating smooth animations in UIKit.", images: [109: "image9.jpg"], createdTime: Date(), reviewTime: "01:25"),
        CodePost(title: "Protocol-Oriented Programming", member_id: 1010, level: 1, timer: "01:10", code: "POP501", description: "Building scalable apps with protocols in Swift.", images: [110: "image10.jpg"], createdTime: Date(), reviewTime: "01:40")
    ]

    func getPost(at index: Int) -> CodePost? {
        guard index >= 0 && index < data.count else { return nil }
        return data[index]
    }
    
    func numberOfPosts() -> Int {
        return data.count
    }
}
