//
//  TILListViewModel.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import UIKit
import UIKit

class TILListViewModel {
    var posts: [TIL] = []
    let tableView = UITableView()
    
    func loadTILList() {
        fetchTILList(page: 0, size: 10) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
}
