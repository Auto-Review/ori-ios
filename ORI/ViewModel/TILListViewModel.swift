//
//  TILListViewModel.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import UIKit

class TILListViewModel {
    var data: [TILPost] = [
        TILPost(title: "Swift Basics", member_id: 1001, timer: "00:30", description: "Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.Introduction to Swift programming fundamentals.", images: [101: "image1.jpg"], createdTime: Date(), reviewTime: "01:00"),
        TILPost(title: "UIKit Layout", member_id: 1002, timer: "00:45", description: "Learn how to create layouts with UIKit.", images: [102: "image2.jpg"], createdTime: Date(), reviewTime: "01:15"),
        TILPost(title: "Networking with URLSession", member_id: 1003, timer: "01:00", description: "Making network requests using URLSession.", images: [103: "image3.jpg"], createdTime: Date(), reviewTime: "01:30"),
        TILPost(title: "Concurrency in Swift", member_id: 1004, timer: "01:15", description: "Explore concurrency in Swift using GCD.", images: [104: "image4.jpg"], createdTime: Date(), reviewTime: "01:45"),
        TILPost(title: "Combine Framework", member_id: 1005, timer: "01:30", description: "Introduction to reactive programming with Combine.", images: [105: "image5.jpg"], createdTime: Date(), reviewTime: "02:00"),
        TILPost(title: "SwiftUI Basics", member_id: 1006, timer: "00:20", description: "Building user interfaces with SwiftUI.", images: [106: "image6.jpg"], createdTime: Date(), reviewTime: "00:40"),
        TILPost(title: "Core Data Basics", member_id: 1007, timer: "00:40", description: "Understanding Core Data for data persistence.", images: [107: "image7.jpg"], createdTime: Date(), reviewTime: "01:10"),
        TILPost(title: "Working with JSON", member_id: 1008, timer: "00:50", description: "Parsing JSON data in Swift applications.", images: [108: "image8.jpg"], createdTime: Date(), reviewTime: "01:20"),
        TILPost(title: "Animations in UIKit", member_id: 1009, timer: "00:55", description: "Creating smooth animations in UIKit.", images: [109: "image9.jpg"], createdTime: Date(), reviewTime: "01:25"),
        TILPost(title: "Protocol-Oriented Programming", member_id: 1010, timer: "01:10", description: "Building scalable apps with protocols in Swift.", images: [110: "image10.jpg"], createdTime: Date(), reviewTime: "01:40"),
        TILPost(title: "MVVM Architecture", member_id: 1011, timer: "01:00", description: "Implementing MVVM pattern in Swift projects.", images: [111: "image11.jpg"], createdTime: Date(), reviewTime: "01:30"),
        TILPost(title: "Working with Alamofire", member_id: 1012, timer: "01:20", description: "Simplifying networking with Alamofire.", images: [112: "image12.jpg"], createdTime: Date(), reviewTime: "01:50"),
        TILPost(title: "Swift Error Handling", member_id: 1013, timer: "00:35", description: "Effective error handling techniques in Swift.", images: [113: "image13.jpg"], createdTime: Date(), reviewTime: "01:05"),
        TILPost(title: "Advanced Swift Generics", member_id: 1014, timer: "01:40", description: "Mastering generics for type-safe programming.", images: [114: "image14.jpg"], createdTime: Date(), reviewTime: "02:10"),
        TILPost(title: "Auto Layout in UIKit", member_id: 1015, timer: "00:50", description: "Using Auto Layout to create responsive interfaces.", images: [115: "image15.jpg"], createdTime: Date(), reviewTime: "01:20"),
        TILPost(title: "Handling Push Notifications", member_id: 1016, timer: "01:05", description: "Setting up and managing push notifications.", images: [116: "image16.jpg"], createdTime: Date(), reviewTime: "01:35"),
        TILPost(title: "In-App Purchases", member_id: 1017, timer: "01:25", description: "Integrating in-app purchases into your app.", images: [117: "image17.jpg"], createdTime: Date(), reviewTime: "01:55"),
        TILPost(title: "Unit Testing in Swift", member_id: 1018, timer: "00:45", description: "Writing effective unit tests in Swift.", images: [118: "image18.jpg"], createdTime: Date(), reviewTime: "01:15"),
        TILPost(title: "Working with RxSwift", member_id: 1019, timer: "01:30", description: "Reactive programming concepts using RxSwift.", images: [119: "image19.jpg"], createdTime: Date(), reviewTime: "02:00"),
        TILPost(title: "Localization in iOS", member_id: 1020, timer: "00:55", description: "Localizing your iOS applications for multiple languages.", images: [120: "image20.jpg"], createdTime: Date(), reviewTime: "01:25"),
        TILPost(title: "App Extensions in iOS", member_id: 1021, timer: "01:00", description: "Creating extensions for your iOS applications.", images: [121: "image21.jpg"], createdTime: Date(), reviewTime: "01:30"),
        TILPost(title: "Keychain Services", member_id: 1022, timer: "00:30", description: "Storing sensitive data securely with Keychain.", images: [122: "image22.jpg"], createdTime: Date(), reviewTime: "01:00"),
        TILPost(title: "Custom Controls in UIKit", member_id: 1023, timer: "01:15", description: "Building reusable custom controls in UIKit.", images: [123: "image23.jpg"], createdTime: Date(), reviewTime: "01:45"),
        TILPost(title: "Handling App Life Cycle", member_id: 1024, timer: "00:40", description: "Understanding the life cycle of an iOS app.", images: [124: "image24.jpg"], createdTime: Date(), reviewTime: "01:10"),
        TILPost(title: "Advanced Auto Layout", member_id: 1025, timer: "01:35", description: "Creating complex layouts with Auto Layout.", images: [125: "image25.jpg"], createdTime: Date(), reviewTime: "02:05"),
        TILPost(title: "App Performance Optimization", member_id: 1026, timer: "01:10", description: "Optimizing your app for better performance.", images: [126: "image26.jpg"], createdTime: Date(), reviewTime: "01:40"),
        TILPost(title: "Integrating Google Maps", member_id: 1027, timer: "01:25", description: "Using Google Maps SDK in your iOS app.", images: [127: "image27.jpg"], createdTime: Date(), reviewTime: "01:55"),
        TILPost(title: "Swift Memory Management", member_id: 1028, timer: "00:50", description: "Understanding memory management principles in Swift.", images: [128: "image28.jpg"], createdTime: Date(), reviewTime: "01:20"),
        TILPost(title: "Custom Fonts and Dynamic Type", member_id: 1029, timer: "00:35", description: "Using custom fonts with Dynamic Type in your app.", images: [129: "image29.jpg"], createdTime: Date(), reviewTime: "01:05"),
        TILPost(title: "Debugging Techniques in Xcode", member_id: 1030, timer: "01:00", description: "Effective debugging techniques for iOS apps.", images: [130: "image30.jpg"], createdTime: Date(), reviewTime: "01:30")
    ]

    func getPost(at index: Int) -> TILPost? {
        guard index >= 0 && index < data.count else { return nil }
        return data[index]
    }
    
    func numberOfPosts() -> Int {
        return data.count
    }
    
}

extension Notification.Name {
    static let didUpdateData = Notification.Name("didUpdateData")
}
