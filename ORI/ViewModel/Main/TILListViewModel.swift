//
//  TILListViewModel.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import UIKit

class TILListViewModel {
    var posts: [TIL] = []
    let tableView = UITableView()
    
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
