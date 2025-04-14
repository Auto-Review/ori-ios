//
//  TILModel.swift
//  ORI
//
//  Created by Song Kim on 3/4/25.
//

import Foundation

struct TILListResponse: Decodable {
    let dtoList: [TIL]
    let totalPage: Int
}

struct TIL: Decodable {
    let id: Int
    let writerId: Int
    let writerEmail: String
    let writerNickName: String
    let title: String
    let content: String
    let createdDate: String
}
