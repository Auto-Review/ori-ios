//
//  SwiftUIView.swift
//  ORI
//
//  Created by Song Kim on 3/4/25.
//

import UIKit
import Alamofire

// 전체 TIL 리스트
func fetchTILList(page: Int, size: Int, completion: @escaping (Result<TILListResponse, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/til/list"
    let parameters: [String: Any] = ["page": page, "size": size]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TILListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                NetworkUtils.handleError(
                    response: response,
                    retryAction: {
                        fetchTILList(page: page, size: size, completion: completion)
                    },
                    completion: completion
                )
            }
        }
}

func fetchTILDeatilList(id: Int, completion: @escaping (Result<TILDetail, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/til/detail/\(id)"
    
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access Token이 없습니다."])))
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TILDetail.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                NetworkUtils.handleError(
                    response: response,
                    retryAction: {
                        fetchTILDeatilList(id: id, completion: completion)
                    },
                    completion: completion
                )
            }
        }
}
