//
//  UIButtonExtensions.swift
//  CommomKit
//
//  Created by 王瘦子 on 2025/9/10.
//

import UIKit

public extension UIButton {
    
    func resizeableBackgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State) {
        
        guard let backgroundImage = backgroundImage else { return }
        let insets = UIEdgeInsets(top: backgroundImage.size.height * 0.5, left: backgroundImage.size.width * 0.5, bottom: backgroundImage.size.height * 0.5, right: backgroundImage.size.width * 0.5)
        let newImage = backgroundImage.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        self.setBackgroundImage(newImage, for: state)
        
    }
}
