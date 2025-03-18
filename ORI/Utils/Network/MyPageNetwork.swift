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
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access Token이 없습니다."])))
        return
    }
    
    let parameters: [String: Any] = ["page": page, "size": size]
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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

func fetchMyCodeList(page: Int, size: Int, completion: @escaping (Result<[Code], Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/code/own"
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access Token이 없습니다."])))
        return
    }
    
    let parameters: [String: Any] = ["page": page, "size": size]
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CodeListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data.dtoList))
            case .failure:
                NetworkConstants.handleError(response: response, completion: completion)
            }
        }
}

func fetchMyInfo(completion: @escaping (Result<Member, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/profile/info"
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
        .responseDecodable(of: MemberResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data))
            case .failure:
                NetworkConstants.handleError(response: response, completion: completion)
            }
        }
}

func updateMyInfo(id: Int, nickname: String) {
    let url = "http://\(NetworkConstants.baseURL)/profile"
    
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    let parameters: [String: Any] = ["id": id, "nickname": nickname]
    
    AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ProfileResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("✅ 프로필 업데이트 성공: \(data)")
            case .failure(let error):
                print("❌ 업데이트 실패: \(error.localizedDescription)")
            }
        }
}
