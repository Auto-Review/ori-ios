//
//  Comment.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI

struct Comments: Decodable {
    var commentList: [Comment]
    var totalPage: Int
}

struct Comment: Decodable {
    let id: Int
    let parentId: Int? // 대댓글일 경우에만 있음
    let writerId: Int
    let writerNickName: String
    let writerEmail: String
    let mentionNickName: String? // 대댓글일 경우에만 있음
    let mentionEmail: String? // 대댓글일 경우에만 있음
    let body: String
    let createdAt: String
    let updatedAt: String
}

struct WriteComment: Decodable {
    let postId: Int
    let body: String
    let isPublic: Bool
    let mentionNickName: String
    let mentionEmail: String
    let parentId: Int? // 대댓글일 경우에만 있음
}
