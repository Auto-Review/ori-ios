//
//  TILListViewModel.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import UIKit

class TILListViewModel {
    var posts: [TIL] = []
    
    var cellModels: [PostCellModel] {
        posts.map {
            PostCellModel(
                title: $0.title,
                author: $0.writerNickName,
                date: String($0.createdDate.prefix(10)),
                reviewCountText: ""
            )
        }
    }
    
    func loadTILList(completion: @escaping () -> Void) {
        fetchTILList(page: 0, size: 10) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                completion()
            case .failure(let error):
                print("Error fetching posts: \(error)")
                completion()
            }
        }
    }
}
