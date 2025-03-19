//
//  Token.swift
//  ORI
//
//  Created by Song Kim on 3/19/25.
//

import Foundation

struct TokenResponse: Decodable {
    let status: String
    let data: String
    let message: String
}
