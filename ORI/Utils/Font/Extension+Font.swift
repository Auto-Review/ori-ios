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
    static let KopubBold = "KoPubWorldDotumBold"
    static let KopubLight = "KoPubWorldDotumLight"
}

extension UIFont {
    class func blackhansans(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.BlackHanSans, size: size)!
    }
    class func kopubBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.KopubBold, size: size)!
    }
    class func kopubLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.KopubLight, size: size)!
    }
}
