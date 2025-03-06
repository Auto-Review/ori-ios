//
//  NetworkConstants.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import UIKit

struct NetworkConstants {
    static let baseURL = Bundle.main.infoDictionary?["SERVER_API_URL"] as? String ?? ""
}
