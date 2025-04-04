//
//  SwiftUIView.swift
//  ORI
//
//  Created by Song Kim on 3/4/25.
//

import UIKit
import Alamofire

// 전체 TIL 리스트
func fetchTILList(page: Int, size: Int, completion: @escaping (Result<[TIL], Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/til/list"
    let parameters: [String: Any] = ["page": page, "size": size]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TILListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data.dtoList))
            case .failure:
                NetworkConstants.handleError(response: response, completion: completion)
            }
        }
}
