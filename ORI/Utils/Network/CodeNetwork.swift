//
//  CodeNetwork.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import UIKit
import Alamofire

// 전체 Code 리스트
func fetchCodeList(page: Int, size: Int, completion: @escaping (Result<[Code], Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/code/list?page=0&size=5"
    let parameters: [String: Any] = ["page": page, "size": size]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CodeListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data.dtoList))
            case .failure(let error):
                print("Error fetching posts: \(error)")
                completion(.failure(error))
            }
        }
}
