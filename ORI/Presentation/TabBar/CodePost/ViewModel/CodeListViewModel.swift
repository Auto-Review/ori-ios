//
//  CodeListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import UIKit

class CodeListViewModel {
    var posts: [Code] = []
    
    private var currentCodePage = 0
    private var isCodeFetching = false
    private var lastCodePage = false
    
    func resetMyCodeList() {
        currentCodePage = 0
        isCodeFetching = false
        posts = []
    }
    
    func fetchMoreAllCodeList(completion: @escaping () -> Void) {
        guard !isCodeFetching, !lastCodePage else {
            completion()
            return
        }
        isCodeFetching = true
        
        fetchCodeList(page: self.currentCodePage, size: 20) { [weak self] result in
            guard let self = self else { return }
            self.isCodeFetching = false
            
            switch result {
            case .success(let response):
                self.posts.append(contentsOf: response.dtoList)
                if response.totalPage <= self.currentCodePage + 1 {
                    self.lastCodePage = true
                } else {
                    self.currentCodePage += 1
                }
            case .failure:
                break
            }
            completion()
        }
    }
    
    var cellModels: [PostCellModel] {
        posts.map {
            PostCellModel(
                title: $0.title,
                author: $0.writerNickName,
                date: String($0.createdDate.prefix(10)),
                reviewCountText: "RE: \($0.commentCount)"
            )
        }
    }
}
