//
//  UIImage+Extension.swift
//  ORI
//
//  Created by Song Kim on 3/19/25.
//

import UIKit

extension UIImage {
    func scaledToFitSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
