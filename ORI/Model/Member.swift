//
//  User.swift
//  ORI
//
//  Created by Song Kim on 11/6/24.
//

import Foundation

struct MemberResponse: Decodable {
    let status: String
    let data: Member
    let message: String
}

struct Member: Decodable {
    let id: Int
    let email: String
    let nickname: String
}

struct ProfileResponse: Decodable {
    let status: String
    let data: Int
    let message: String
}
