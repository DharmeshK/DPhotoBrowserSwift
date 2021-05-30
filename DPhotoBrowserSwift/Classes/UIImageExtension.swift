//
//  UIImagePhotoBrowserExtension.swift
//  DPhotoBrowserSwift
//
//  Created by DK on 30/05/21.
//  Original obj-c created by Michael Waterfall 2013
//
//

import Foundation
import UIKit

public extension UIImage {
    class func imageForResourcePath(path: String, ofType: String, inBundle: Bundle) -> UIImage? {
        if let p = inBundle.path(forResource: path, ofType: ofType) {
            return UIImage(contentsOfFile: p)
        }
        
        return nil
    }

    class func clearImageWithSize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let blank = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return blank
    }
}
