//
//  CodeListViewController.swift
//  ORI
//
//  Created by Song Kim on 10/24/24.
//

import Foundation
import UIKit

class CodeListViewModel {
    var posts: [Code] = []
    var tableView = UITableView()
    
    var didUpdateData: (() -> Void)?
    
    func loadCodeList() {
        fetchCodeList(page: 0, size: 10) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                self?.tableView.reloadData()
                self?.didUpdateData?()
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
}
