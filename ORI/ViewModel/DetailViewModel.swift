//
//  DetailViewModel.swift
//  ORI
//
//  Created by Song Kim on 4/17/25.
//

import SwiftUI

class DetailViewModel {
    var myInfo: Member = Member(id: 0, email: "", nickname: "")
    
    init() {
        fetchMyData()
    }
    
    func fetchMyData() {
        fetchMyProfile() { [weak self] result in
            switch result {
            case .success(let posts):
                self?.myInfo = posts
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
