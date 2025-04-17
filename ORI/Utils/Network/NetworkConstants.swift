//
//  NetworkConstants.swift
//  ORI
//
//  Created by Song Kim on 3/5/25.
//

import UIKit
import Alamofire

struct NetworkConstants {
    static let baseURL = Bundle.main.infoDictionary?["SERVER_API_URL"] as? String ?? ""
    
    static func handleError<T, U>(
        response: DataResponse<U, AFError>,
        retryAction: @escaping () -> Void,
        completion: @escaping (Result<T, Error>) -> Void
    ) where U: Decodable {
        
        if let responseCode = response.response?.statusCode, responseCode == 401 {
            print("🔄 401 Unauthorized → 토큰 갱신 시도")

            TokenNetwork.reissuedTokenFromServer {
                retryAction()
            }

        } else if let error = response.error {
            print("❌ Error: \(error)")
            completion(.failure(error))
        }
    }
}
