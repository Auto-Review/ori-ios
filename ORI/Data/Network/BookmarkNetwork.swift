//
//  BookmarkNetwork.swift
//  ORI
//
//  Created by Song Kim on 5/13/25.
//

import UIKit
import Alamofire

func createTILBookmark() {
    
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
                print("북마크 성공")
            case .failure(let error):
                print("❌ 에러 내용: \(error)")
            }
        }
}

func fetchTILBookmark() {
    
}

func fetchCodeBookmark() {
    
}

func deleteTILBookmark() {
    
}

func deleteCodeBookmark() {
    
}
