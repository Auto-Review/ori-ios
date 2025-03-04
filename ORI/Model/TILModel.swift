//
//  TILModel.swift
//  ORI
//
//  Created by Song Kim on 3/4/25.
//

import Foundation

struct TILListResponse: Decodable {
    let status: String
    let data: TILListData
    let message: String
}

struct TILListData: Decodable {
    let dtoList: [TIL]
    let totalPage: Int
}

struct TIL: Decodable {
    let id: Int
    let title: String
    let content: String
    let member: Member
    let createdDate: String
}

struct Member: Decodable {
    let id: Int
    let email: String
    let nickname: String
}
