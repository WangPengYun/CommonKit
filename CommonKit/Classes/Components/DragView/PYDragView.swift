//
//  PYDragView.swift
//  CommomKit
//
//  Created by 王瘦子 on 2025/9/10.
//

import UIKit

public enum DragDirection {
    // 任意方向
    case any
    // 水平方向
    case horizontal
    // 垂直方向
    case vertical
}

public class PYDragView: UIView, UIGestureRecognizerDelegate {
    
    public typealias DragBlock = ((PYDragView) -> ())?
    
    var clickDragViewBlock: DragBlock
    var beginDragBlock: DragBlock
    var isDragingBlock: DragBlock
    var endDragBlock: DragBlock
    
    
    // 是否可拖拽，默认为ture
    public var isDragEnable = true
    // 可活动范围，设置为CGRectZero默认为父视图范围
    public var dragRect = CGRectZero {
        didSet {
            if dragRect != CGRectZero {
                if let superviewBoundsSize = self.superview?.bounds.size {
                    self.dragRect = CGRect(origin: CGPointZero, size: superviewBoundsSize)
                }
            }
        }
    }
    // 拖拽方向
    public var dragDirection: DragDirection = .any
    // 是否有贴边效果，默认为false
    public var isKeepCloseToBounds = false {
        didSet {
            if isKeepCloseToBounds {
                self.keepCloseToBounds()
            }
        }
    }
    
    private var startPoint: CGPoint?
    private let animationDuration = 0.3
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.clipsToBounds = true
        return contentView
    }()
    
    public override init(frame: CGRect) {
        super.init()
        self.addSubview(self.contentView)
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PYDragView {
    
    private func setup() {
        
        self.imageView.frame = CGRect(origin: CGPointZero, size: self.bounds.size)
        self.contentView.frame = CGRect(origin: CGPointZero, size: self.bounds.size)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(clickDragView))
        self.addGestureRecognizer(singleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragAction(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
    }
  
}

extension PYDragView {
    
    @objc private func clickDragView() {
        self.clickDragViewBlock?(self)
    }
    
    @objc private func dragAction(_ pan: UIPanGestureRecognizer) {
        guard self.isDragEnable else {
            return
        }
        switch pan.state {
        case .began:
            self.beginDragBlock?(self)
            pan.setTranslation(CGPointZero, in: self)
            self.startPoint = pan.translation(in: self)
        case .changed:
            self.isDragingBlock?(self)
            let oldPoint = pan.translation(in: self)
            let newPoint = self.caculate(oldPoint)
            self.center = newPoint
            pan.setTranslation(CGPointZero, in: self)
        case .ended:
            self.endDragBlock?(self)
            self.keepCloseToBounds()
        default:
            break
        }
    }
    
    private func caculate(_ point: CGPoint) -> CGPoint {
        var px = 0.0, py = 0.0
        switch self.dragDirection {
        case .any:
            px = point.x - (self.startPoint?.x ?? 0)
            py = point.y - (self.startPoint?.y ?? 0)
        case .horizontal:
            px = point.x - (self.startPoint?.x ?? 0)
            py = 0
        case .vertical:
            px = 0
            py = point.y - (self.startPoint?.y ?? 0)
        }
        return CGPoint(x: px, y: py)
    }
    
}


extension PYDragView {
    
    private func keepCloseToBounds() {
        let centerX = self.dragRect.origin.x + (self.dragRect.size.width - self.frame.size.width) / 2
        var rect = self.frame
        if self.isKeepCloseToBounds {
            if self.frame.origin.x < self.dragRect.origin.x {
                UIView.animate(withDuration: animationDuration) {
                    rect.origin.x = self.dragRect.origin.x
                    self.frame = rect
                }
            } else {
                UIView.animate(withDuration: animationDuration) {
                    rect.origin.x = self.dragRect.origin.x + self.dragRect.size.width - self.frame.size.width
                    self.frame = rect
                }
            }
        } else {
            if self.frame.origin.x < centerX {
                UIView.animate(withDuration: animationDuration) {
                    rect.origin.x = self.dragRect.origin.x
                    self.frame = rect
                }
            } else {
                UIView.animate(withDuration: animationDuration) {
                    rect.origin.x = self.dragRect.origin.x + self.dragRect.size.width - self.frame.size.width
                    self.frame = rect
                }
            }
        }
        
        if self.frame.origin.y < self.dragRect.origin.y {
            UIView.animate(withDuration: animationDuration) {
                rect.origin.y = self.dragRect.origin.y
                self.frame = rect
            }
        } else if self.dragRect.origin.y + self.dragRect.size.height < self.frame.origin.y + self.frame.size.height {
            UIView.animate(withDuration: animationDuration) {
                rect.origin.y = self.dragRect.origin.y + self.dragRect.size.height - self.frame.size.height
                self.frame = rect
            }
        }
    }
    
    
}
