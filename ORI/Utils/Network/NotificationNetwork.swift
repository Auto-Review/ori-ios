//
//  NotificationNetwork.swift
//  ORI
//
//  Created by Song Kim on 3/21/25.
//

import Foundation
import Alamofire

func fetchNotificationList(completion: @escaping (Result<[Notification], Error>) -> Void) {
    let url = "http://\(NetworkConstants.baseURL)/notification/own"
    
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
        .responseDecodable(of: NotificationResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.data))
            case .failure:
                NetworkConstants.handleError(response: response, completion: completion)
            }
        }
}
