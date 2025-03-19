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
    private var myTILPosts: [TIL] = []
    private var myCodePosts: [Code] = []
    var myInfo: Member = Member(id: 0, email: "", nickname: "")


    var didUpdateData: (() -> Void)?
    var didUpdateMyData: (() -> Void)?
    var didFailWithError: ((Error) -> Void)?
    
    func fetchPostData() {
        fetchMyTILList(page: 0, size: 10) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.myTILPosts = posts
                self?.didUpdateData?()
            case .failure(let error):
                self?.didFailWithError?(error)
            }
        }
        
        fetchMyCodeList(page: 0, size: 10) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.myCodePosts = posts
                self?.didUpdateData?()
            case .failure(let error):
                self?.didFailWithError?(error)
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
