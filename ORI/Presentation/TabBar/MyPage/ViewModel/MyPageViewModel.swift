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
    let userId = UserDefaults.standard.integer(forKey: "userId")
    let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "user"
    let userName = UserDefaults.standard.string(forKey: "userName") ?? "user"
    
    // 코드 포스트 무한 스크롤
    private var currentCodePage = 0
    private var isCodeFetching = false
    private var lastCodePage = false
    
    func resetMyCodeList() {
        currentCodePage = 0
        isCodeFetching = false
        lastCodePage = false
        myCodePosts = []
    }
    
    func loadMoreMyCodeList(completion: @escaping () -> Void) {
        guard !isCodeFetching, !lastCodePage else {
            completion()
            return
        }
        isCodeFetching = true
        
        fetchMyCodeList(page: currentCodePage, size: 10) { [weak self] result in
            guard let self = self else { return }
            self.isCodeFetching = false
            
            switch result {
            case .success(let response):
                self.myCodePosts.append(contentsOf: response.dtoList)
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
    
    // TIL 포스트 무한 스크롤
    private var currentTILPage = 0
    private var isTILFetching = false
    private var lastTILPage = false
    
    func resetMyTILList() {
        currentTILPage = 0
        isTILFetching = false
        lastTILPage = false
        myTILPosts = []
    }
    
    func loadMoreMyTILList(completion: @escaping () -> Void) {
        guard !isTILFetching, !lastTILPage else {
            completion()
            return
        }
        isTILFetching = true
        
        fetchMyTILList(page: 0, size: 10) { [weak self] result in
            guard let self = self else { return }
            self.isTILFetching = false
            
            switch result {
            case .success(let response):
                self.myTILPosts.append(contentsOf: response.dtoList)
                if response.totalPage <= self.currentTILPage + 1 {
                    self.lastTILPage = true
                } else {
                    self.currentTILPage += 1
                }
            case .failure:
                break
            }
            completion()
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
