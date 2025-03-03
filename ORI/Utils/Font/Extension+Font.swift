//
//  Font.swift
//  ORI
//
//  Created by Song Kim on 3/3/25.
//

import Foundation
import UIKit

struct AppFontName {
    static let BlackHanSans = "BlackHanSans-Regular"
}

extension UIFont {
    class func blackhansans(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.BlackHanSans, size: size)!
    }
}
