//
//  Bookmark.swift
//  ORI
//
//  Created by Song Kim on 5/13/25.
//

import UIKit

struct CodeBookmark: Decodable {
    let dtoList: [CodeBookmarkPost]
    let totalPage: Int
}

struct CodeBookmarkPost: Decodable {
    let id: Int
    let codePostId: Int
    let codePostTitle: String
    let commentCount: Int
    let writer: String
    let updateAt: String
}
