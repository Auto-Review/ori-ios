//
//  CodeModel.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

struct CodeListResponse: Decodable {
    let status: String
    let data: CodeListData
    let message: String
}

struct CodeListData: Decodable {
    let dtoList: [Code]
    let totalPage: Int
}

struct Code: Decodable {
    let id: Int
    let writerId: Int
    let writerEmail: String
    let writerNickName: String
    let title: String
    let level: Int
    let description: String
    let createdDate: String
}
