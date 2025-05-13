//
//  CodeModel.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

struct MyCodeListResponse: Decodable {
    let dtoList: [MyCode]
    let totalPage: Int
}

struct CodeListResponse: Decodable {
    let dtoList: [Code]
    let totalPage: Int
}

struct MyCode: Decodable {
    let id: Int
    let writerId: Int
    let writerEmail: String
    let writerNickName: String
    let title: String
    let level: Int
    let commentCount: Int
    let reviewCount: Int
    let createdDate: String
}

struct Code: Decodable {
    let id: Int
    let writerId: Int
    let writerEmail: String
    let writerNickName: String
    let title: String
    let level: Int
    let commentCount: Int
    let description: String
    let createdDate: String
    let isPublic: Bool  // Swift에서는 예약어 사용 불가

    private enum CodingKeys: String, CodingKey {
        case id
        case writerId
        case writerEmail
        case writerNickName
        case title
        case level
        case commentCount
        case description
        case createdDate
        case isPublic = "public"  // 매핑 처리
    }
}

struct CodeDetail: Decodable {
    let id: Int
    let writerId: Int
    let writerEmail: String
    let writerNickName: String
    let title: String
    let level: Int
    let reviewDay: String
    let description: String
    let language: String
    let code: String
    let dtoList: [Review]
    let createDate: String
}
