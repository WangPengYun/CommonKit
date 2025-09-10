//
//  UIImageExtensions.swift
//  CommomKit
//
//  Created by 王瘦子 on 2025/9/10.
//

import UIKit

public extension UIImage {
    
    static func createImage(with color: UIColor, rect: CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    static func setCorner(with image: UIImage?, cornerRadius: CGFloat) -> UIImage? {
        
        guard let size = image?.size else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        context?.clip()
        image?.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func fixOrientation() -> UIImage? {
        
       return nil
    }
    
}
