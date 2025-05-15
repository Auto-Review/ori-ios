//
//  CodeDetailViewModel.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI

class CodeDetailViewModel {
    var codePostComments: Comments = Comments(commentList: [], totalPage: 0)
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let userName = UserDefaults.standard.string(forKey: "userName") ?? "user"
    let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "user"
    
    func loadCommentList(codePostId: Int, page: Int, size: Int, completion: @escaping () -> Void) {
        fetchCodeCommentList(codePostId: codePostId, page: page, size: size) { [weak self] result in
            switch result {
            case .success(let lists):
                self?.codePostComments = lists
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createComment(text: String, postId: Int, completion: @escaping (Bool) -> Void) {
        let comment = WriteComment(
            postId: postId,
            body: text,
            isPublic: true,
            mentionNickName: userName,
            mentionEmail: userEmail,
            parentId: nil
        )
        createCodeComment(comment: comment) { success in
            if success {
                completion(true)
            }
        }
    }
}
