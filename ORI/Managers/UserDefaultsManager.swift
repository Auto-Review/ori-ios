//
//  UserDefaultsManager.swift
//  ORI
//
//  Created by Song Kim on 5/15/25.
//

import UIKit

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    private enum Key {
        static let userId = "userId"
        static let userName = "userName"
        static let userEmail = "userEmail"
    }

    var userId: Int {
        return defaults.integer(forKey: Key.userId)
    }

    var userName: String {
        return defaults.string(forKey: Key.userName) ?? "user"
    }

    var userEmail: String {
        return defaults.string(forKey: Key.userEmail) ?? "user"
    }
}
