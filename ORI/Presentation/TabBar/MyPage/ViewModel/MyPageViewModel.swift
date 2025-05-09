//
//  ProfileViewModel.swift
//  ORI
//
//  Created by Song Kim on 11/6/24.
//

import Foundation
import UIKit

class MyPageViewModel {
    var isCode = true
    
    var myTILPosts: [TIL] = []
    var myCodePosts: [MyCode] = []
    var myInfo: Member = Member(id: 0, email: "", nickname: "")
    
    var didUpdateMyData: (() -> Void)?
    var didFailWithError: ((Error) -> Void)?
    
    private var currentPage = 0
    private var isFetching = false
    private var lastPage = false
    
    func resetMyCodeList() {
        currentPage = 0
        lastPage = false
        myCodePosts = []
    }
    
    func loadMoreMyCodeList(completion: @escaping () -> Void) {
        guard !isFetching, !lastPage else {
            completion()
            return
        }
        
        isFetching = true
        fetchMyCodeList(page: currentPage, size: 10) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                self.myCodePosts.append(contentsOf: response.dtoList)
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
    
    func loadMyTILList(completion: @escaping () -> Void) {
        fetchMyTILList(page: 0, size: 10) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.myTILPosts = posts
                completion()
            case .failure(_):
                completion()
            }
        }
    }
    
    func fetchMyData() {
        fetchMyProfile() { [weak self] result in
            switch result {
            case .success(let posts):
                self?.myInfo = posts
                self?.didUpdateMyData?()
            case .failure(let error):
                self?.didFailWithError?(error)
            }
        }
    }
    
    func numberOfPosts() -> Int {
        return isCode ? myCodePosts.count : myTILPosts.count
    }
    
    func postTitle(at index: Int) -> String? {
        if isCode {
            guard index >= 0 && index < myCodePosts.count else { return nil }
            return myCodePosts[index].title
        } else {
            guard index >= 0 && index < myTILPosts.count else { return nil }
            return myTILPosts[index].title
        }
    }
    
    func postDate(at index: Int) -> String? {
        if isCode {
            guard index >= 0 && index < myCodePosts.count else { return nil }
            return myCodePosts[index].createdDate.prefix(10).description
        } else {
            guard index >= 0 && index < myTILPosts.count else { return nil }
            return myTILPosts[index].createdDate.prefix(10).description
        }
    }
}
