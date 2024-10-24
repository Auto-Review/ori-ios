//
//  TILPost.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import Foundation

struct TILPost {
    var title: String
    var member_id: Int64
    var timer: String
    var code: String
    var description: String
    var images: [Int64: String]
    var createdTime: Date
    var reviewTime: String
}

struct CodePost {
    var title: String
    var member_id: Int64
    var level: Double
    var timer: String
    var code: String
    var description: String
    var images: [Int64: String]
    var createdTime: Date
    var reviewTime: String
}
