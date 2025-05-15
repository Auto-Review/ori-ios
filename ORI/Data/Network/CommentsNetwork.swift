//
//  CommentsNetwork.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI
import Alamofire

func fetchTILCommentList(tilPostId: Int, page: Int, size: Int, completion: @escaping (Result<Comments, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/til-post/\(tilPostId)/USER/comments"
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

func fetchCodeCommentList(codePostId: Int, page: Int, size: Int, completion: @escaping (Result<Comments, Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/code-post/\(codePostId)/USER/comments"
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    
    let parameters: [String: Any] = ["page": page, "size": size, "codePostId": codePostId]
    
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
                        fetchCodeCommentList(codePostId: codePostId, page: page, size: size, completion: completion)
                    },
                    completion: completion
                )
            }
        }
}

func createTILComment(comment: WriteComment, completion: @escaping (Bool) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/til-post/comment"
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
                completion(true)
            case .failure(let error):
                print("❌ 에러 내용: \(error.localizedDescription)")
            }
        }
}

func createCodeComment(comment: WriteComment, completion: @escaping (Bool) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/code-post/comment"
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
                completion(true)
            case .failure(let error):
                print("❌ 에러 내용: \(error.localizedDescription)")
                completion(false)
            }
        }
}

func editTILComment(commentId: Int, body: String, isPublic: Bool, mentionNickName: String, mentionEmail: String, completion: @escaping (Bool) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/til-post/comment"
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    let parameters: [String: Any] = ["commentId": commentId, "body": body, "isPublic": isPublic, "mentionNickName": mentionNickName, "mentionEmail": mentionEmail]
    
    AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success(_ ):
                completion(true)
            case .failure(let error):
                print("❌ 에러 내용: \(error.localizedDescription)")
                completion(false)
            }
        }
}

func editCodeComment(commentId: Int, body: String, isPublic: Bool, mentionNickName: String, mentionEmail: String, completion: @escaping (Bool) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/code-post/comment"
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        print("❌ Access Token이 없습니다.")
        return
    }
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    let parameters: [String: Any] = ["commentId": commentId, "body": body, "isPublic": isPublic, "mentionNickName": mentionNickName, "mentionEmail": mentionEmail]
    
    AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success(_ ):
                completion(true)
            case .failure(let error):
                print("❌ 에러 내용: \(error.localizedDescription)")
                completion(false)
            }
        }
}

func deleteTILComment(commentId: Int, writerId: Int, completion: @escaping (Bool) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/til-post/comment"
    
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    let parameters: [String: Any] = ["commentId": commentId, "writerId": writerId]
    
    AF.request(url,method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
}


func deleteCodeComment(commentId: Int, writerId: Int, completion: @escaping (Bool) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/code-post/comment"
    
    guard let accessToken = KeychainManager.load(key: "accessToken"), !accessToken.isEmpty else {
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": accessToken,
        "Content-Type": "application/json"
    ]
    
    let parameters: [String: Any] = ["commentId": commentId, "writerId": writerId]
    
    AF.request(url,method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<300)
        .response { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
}
