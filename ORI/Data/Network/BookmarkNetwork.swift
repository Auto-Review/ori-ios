//
//  BookmarkNetwork.swift
//  ORI
//
//  Created by Song Kim on 5/13/25.
//

import UIKit
import Alamofire

func createTILBookmark(id: Int) {
    let url = "http://\(NetworkConstants.baseURL)/post/til/bookmark"
    
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    let parameters: [String: Any] = ["postId": id]
    
    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                print("TIL 북마크 성공")
            case .failure(let error):
                print("❌ 에러 내용: \(error)")
            }
        }
}

func createCodeBookmark(id: Int) {
    let url = "http://\(NetworkConstants.baseURL)/post/code/bookmark"
    
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    let parameters: [String: Any] = ["codePostId": id]
    
    AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                print("Code 북마크 성공")
            case .failure(let error):
                print("❌ 에러 내용: \(error)")
            }
        }
}

func fetchTILBookmark() {
    
}

func fetchCodeBookmark(page: Int, size: Int, completion: @escaping (Result<CodeBookmark, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/post/code/bookmark/list"
    
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    let parameters: [String: Any] = ["page": page, "size": size]
    
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CodeBookmark.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
}

func deleteTILBookmark() {
    
}

func deleteCodeBookmark() {
    
}
