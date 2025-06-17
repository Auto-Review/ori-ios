//
//  MainNavigationBar.swift
//  ORI
//
//  Created by Song Kim on 2/24/25.
//

import UIKit

private var id = 0
private var isBookmark = false
private var isCodePost = true
private var bookmarkButton: UIButton?

extension UIViewController {
    func detailNavigationBar(text: String, postId: Int, bookmarked: Bool, isCode: Bool) {
        id = postId
        isBookmark = bookmarked
        isCodePost = isCode

        // Title
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = " \(text)"
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.sizeToFit()
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)

        // Close Button
        let closeButton: UIButton = {
            let button = UIButton()
            let icon = UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
            let resizedIcon = icon?.scaledToFitSize(CGSize(width: 12, height: 17)).withRenderingMode(.alwaysTemplate)
            button.setImage(resizedIcon, for: .normal)
            button.tintColor = .systemGray
            return button
        }()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        let closeItem = UIBarButtonItem(customView: closeButton)
        navigationItem.leftBarButtonItems = [closeItem, titleItem]

        // Bookmark Button
        bookmarkButton = UIButton(type: .system)
        bookmarkButton?.addTarget(self, action: #selector(clickbookmarkButton), for: .touchUpInside)
        updateBookmarkButtonUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton!)
    }

    @objc func clickbookmarkButton(isCode: Bool) {
        isBookmark.toggle()
        updateBookmarkButtonUI()
        if isCodePost {
            createCodeBookmark(id: id)
        } else {
            createTILBookmark(id: id)
        }
    }

    private func updateBookmarkButtonUI() {
        let imageName = isBookmark ? "bookmark.fill" : "bookmark"
        let icon = UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        let resizedIcon = icon?.scaledToFitSize(CGSize(width: 24, height: 21)).withRenderingMode(.alwaysTemplate)

        bookmarkButton?.setImage(resizedIcon, for: .normal)
        bookmarkButton?.tintColor = isBookmark ? .baseYellow : .systemGray4
        bookmarkButton?.backgroundColor = .clear
    }
}
