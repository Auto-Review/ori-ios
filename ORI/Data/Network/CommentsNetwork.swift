//
//  CommentsNetwork.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI
import Alamofire

func fetchTILCommentList(tilPostId: Int, page: Int, size: Int, completion: @escaping (Result<Comments, Error>) -> Void) {
    let url = "http://\(NetworkUtils.baseURL)/til-post/\(tilPostId)/USER/comments"
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    
    let parameters: [String: Any] = ["page": page, "size": size, "tilPostId": tilPostId]
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Comments.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                NetworkUtils.handleError(
                    response: response,
                    retryAction: {
                        fetchTILCommentList(tilPostId: tilPostId, page: page, size: size, completion: completion)
                    },
                    completion: completion
                )
            }
        }
}

func createTILComment(comment: WriteComment) {
    let url = "http://\(NetworkUtils.baseURL)/til-post/comment"
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    let parameters: [String: Any] = ["postId": comment.postId, "body": comment.body, "isPublic": comment.isPublic, "mentionNickName": comment.mentionNickName, "mentionEmail": comment.mentionEmail, "parentId": comment.parentId as Any]
    
    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success(_ ):
                print("✅ 댓글 등록 성공")
                fetchTILCommentList(tilPostId: comment.postId, page: 0, size: 10) { result in
                }
            case .failure(let error):
                print("❌ 에러 내용: \(error.localizedDescription)")
            }
        }
}
