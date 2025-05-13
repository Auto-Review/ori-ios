//
//  DetailViewModel.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI

class DetailViewModel {
    var myInfo: Member = Member(id: 0, email: "", nickname: "")
    var tilPostComments: Comments = Comments(commentList: [], totalPage: 0)
    
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
    
    func loadMyData() {
        fetchMyProfile() { [weak self] result in
            switch result {
            case .success(let posts):
                self?.myInfo = posts
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
        createTILComment(comment: comment)
    }
}
