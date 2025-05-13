//
//  Review.swift
//  ORI
//
//  Created by Song Kim on 5/13/25.
//

struct Review: Decodable {
    let id: Int
    let description: String
    let code: String
    let createdAt: String
    let updatedAt: String
}
