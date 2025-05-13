//
//  CodeNetwork.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import UIKit
import Alamofire

// 전체 Code 리스트
func fetchCodeList(page: Int, size: Int, completion: @escaping (Result<CodeListResponse, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/code/list"
    let parameters: [String: Any] = ["page": page, "size": size]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CodeListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                NetworkUtils.handleError(
                    response: response,
                    retryAction: {
                        fetchCodeList(page: page, size: size, completion: completion)
                    },
                    completion: completion
                )
            }
        }
}

func fetchCodeDeatilList(id: Int, completion: @escaping (Result<CodeDetail, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/code/detail/\(id)"
    
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
        .responseDecodable(of: CodeDetail.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                NetworkUtils.handleError(
                    response: response,
                    retryAction: {
                        fetchCodeDeatilList(id: id, completion: completion)
                    },
                    completion: completion
                )
            }
        }
}
