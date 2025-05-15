//
//  CodeDetailViewModel.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI

class CodeDetailViewModel {
    var myInfo: Member = Member(id: 0, email: "", nickname: "")
    var codePostComments: Comments = Comments(commentList: [], totalPage: 0)
    
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
    
    func loadMyData(completion: @escaping (Member) -> Void) {
        fetchMyProfile() { [weak self] result in
            switch result {
            case .success(let posts):
                self?.myInfo = posts
                completion(posts)
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
            mentionNickName: myInfo.nickname,
            mentionEmail: myInfo.email,
            parentId: nil
        )
        createCodeComment(comment: comment)
    }
}
