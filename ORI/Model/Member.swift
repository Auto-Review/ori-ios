//
//  User.swift
//  ORI
//
//  Created by Song Kim on 11/6/24.
//

import Foundation

struct User {
    var name: String
    var email: String
    var token: String
}

struct Member: Decodable {
    let id: Int
    let email: String
    let nickname: String
}
