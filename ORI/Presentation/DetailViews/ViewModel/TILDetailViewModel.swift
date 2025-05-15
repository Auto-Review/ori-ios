//
//  TILDetailViewModel.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI

class TILDetailViewModel {
    var tilPostComments: Comments = Comments(commentList: [], totalPage: 0)
    let userId = UserDefaultsManager.shared.userId
    let userName = UserDefaultsManager.shared.userName
    let userEmail = UserDefaultsManager.shared.userEmail
    
    func loadCommentList(tilPostId: Int, page: Int, size: Int, completion: @escaping () -> Void) {
        fetchTILCommentList(tilPostId: tilPostId, page: page, size: size) { [weak self] result in
            switch result {
            case .success(let lists):
                self?.tilPostComments = lists
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
        createTILComment(comment: comment) { success in
            if success {
                print("✅ 댓글 등록 성공")
                completion(true)
            }
        }
    }
    
    func editComment(text: String, id: Int) {
        editTILComment(commentId: id, body: text, isPublic: true, mentionNickName: userName, mentionEmail: userEmail) { success in
            if success {
                print("✅ 댓글 수정 성공")
            }
        }
    }
    
    func deleteComment(id: Int, completion: @escaping (Bool) -> Void) {
        deleteTILComment(commentId: id, writerId: userId) { success in
            if success {
                print("✅ 댓글 삭제 성공")
                completion(true)
            }
        }
    }
}
