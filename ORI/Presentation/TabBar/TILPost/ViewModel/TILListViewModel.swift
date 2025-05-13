//
//  TILListViewModel.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import UIKit

class TILListViewModel {
    var posts: [TIL] = []
    private var currentPage = 0
    private var isFetching = false
    private var lastPage = false
    
    func resetMyCodeList() {
        currentPage = 0
        isFetching = false
        lastPage = false
        posts = []
    }
    
    func loadMoreAllTILList(completion: @escaping () -> Void) {
        guard !isFetching, !lastPage else {
            completion()
            return
        }
        isFetching = true
        
        fetchTILList(page: self.currentPage, size: 20) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                self.posts.append(contentsOf: response.dtoList)
                if response.totalPage <= self.currentPage + 1 {
                    self.lastPage = true
                } else {
                    self.currentPage += 1
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
                reviewCountText: ""
            )
        }
    }
}
