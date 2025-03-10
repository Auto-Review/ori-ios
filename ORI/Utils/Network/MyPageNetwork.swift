//
//  MyPageNetwork.swift
//  ORI
//
//  Created by Song Kim on 3/10/25.
//

import Foundation
import Alamofire

func fetchMyTILList(page: Int, size: Int, completion: @escaping (Result<[TIL], Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/til/own"
    guard let token = KeychainManager.load(key: "accessToken"), !token.isEmpty else {
        print("❌ Access Token이 없습니다.")
        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access Token이 없습니다."])))
        return
    }
    
    let parameters: [String: Any] = ["page": page, "size": size]
    
    let headers: HTTPHeaders = [
        "Authorization": "\(token)",
        "Content-Type": "application/json"
    ]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: TILListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data.dtoList))
            case .failure(let error):
                if let responseCode = response.response?.statusCode, responseCode == 401 {
                    print("🔄 401 Unauthorized 발생 → Access Token 갱신 시도")
                } else {
                    print("❌ Error fetching posts: \(error)")
                    completion(.failure(error))
                }
            }
        }
}

func fetchMyCodeList(page: Int, size: Int, completion: @escaping (Result<[Code], Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/code/own"
    guard let token = KeychainManager.load(key: "accessToken"), !token.isEmpty else {
        print("❌ Access Token이 없습니다.")
        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access Token이 없습니다."])))
        return
    }
    
    let parameters: [String: Any] = ["page": page, "size": size]
    
    let headers: HTTPHeaders = [
        "Authorization": "\(token)",
        "Content-Type": "application/json"
    ]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CodeListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data.dtoList))
            case .failure(let error):
                if let responseCode = response.response?.statusCode, responseCode == 401 {
                    print("🔄 401 Unauthorized 발생 → Access Token 갱신 시도")
                } else {
                    print("❌ Error fetching posts: \(error)")
                    completion(.failure(error))
                }
            }
        }
}

func fetchMyInfo(completion: @escaping (Result<Member, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/profile/info"
    guard let token = KeychainManager.load(key: "accessToken"), !token.isEmpty else {
        print("❌ Access Token이 없습니다.")
        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access Token이 없습니다."])))
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": "\(token)",
        "Content-Type": "application/json"
    ]
    
    AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: MemberResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data))
            case .failure(let error):
                if let responseCode = response.response?.statusCode, responseCode == 401 {
                    print("🔄 401 Unauthorized 발생 → Access Token 갱신 시도")
                } else {
                    print("❌ Error fetching posts: \(error)")
                    completion(.failure(error))
                }
            }
        }
}
