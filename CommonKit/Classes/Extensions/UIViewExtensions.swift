//
//  UIViewExtensions.swift
//  CommomKit
//
//  Created by 王瘦子 on 2025/9/10.
//

import UIKit

public extension UIView {
    
    func addGradientBorder(cornerRadius: CGFloat = 10.0, lineWidth: CGFloat = 1.0, colors: [CGColor]) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = cornerRadius
        
        let maskLayer = CAShapeLayer()
        maskLayer.lineWidth = lineWidth
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: self.bounds.width - lineWidth, height: self.bounds.height - lineWidth), cornerRadius: cornerRadius).cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = maskLayer
        
        self.layer.addSublayer(gradientLayer)
        
    }
    
    func addGradientLayer(cornerRadius: CGFloat = 10.0, colors: [CGColor]) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0, 1]
        self.layer.addSublayer(gradientLayer)
        
    }
    
    func setCorner(cornerRadii: CGSize, rectCorner: UIRectCorner = .allCorners) {
        
        let mask = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.path = mask.cgPath
        self.layer.mask = maskLayer
                                
    }

}
