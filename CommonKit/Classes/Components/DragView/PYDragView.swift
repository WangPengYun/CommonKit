//
//  PYDragView.swift
//  CommomKit
//
//  Created by wangpengyun on 2025/9/10.
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

public class PYDragView: UIView {
    
    public typealias DragBlock = ((PYDragView) -> ())
    
    public var clickDragViewBlock: DragBlock? = nil
    public var beginDragBlock: DragBlock? = nil
    public var isDragingBlock: DragBlock? = nil
    public var endDragBlock: DragBlock? = nil
    
    // 是否可拖拽，默认为ture
    public var isDragEnable = true
    // 拖拽方向
    public var dragDirection: DragDirection = .any
    // 拖拽动画时长
    public var animationDuration = 0.3
    // 可活动范围，设置为CGRectZero默认为父视图范围
    public var dragRect = CGRectZero {
        didSet {
            self.keepCloseToBounds()
        }
    }
    // 是否有贴边效果，默认为false
    public var isKeepCloseToBounds = false {
        didSet {
            if isKeepCloseToBounds {
                self.keepCloseToBounds()
            }
        }
    }
    
    private var startPoint: CGPoint?
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

}

extension PYDragView {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if dragRect == CGRectZero {
            if let superviewBoundsSize = self.superview?.bounds.size {
                self.dragRect = CGRect(origin: CGPointZero, size: superviewBoundsSize)
            }
        }
    }
    
    private func setup() {
        self.clipsToBounds = true
        self.imageView.frame = CGRect(origin: CGPointZero, size: self.bounds.size)
        self.addSubview(self.imageView)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleClick))
        self.addGestureRecognizer(singleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragAction(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
        
        singleTapGesture.require(toFail: panGesture)
    }

  
}

extension PYDragView {
    
    @objc func handleClick() {
        self.clickDragViewBlock?(self)
    }
    
    @objc func handleDragAction(_ pan: UIPanGestureRecognizer) {
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
            self.keepCloseToBounds()
            self.endDragBlock?(self)
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
        return CGPoint(x: self.center.x + px, y: self.center.y + py)
    }
    
}


extension PYDragView {
    
    private func keepCloseToBounds() {
        let centerX = self.dragRect.origin.x + (self.dragRect.size.width - self.frame.size.width) / 2
        var rect = self.frame
        if self.isKeepCloseToBounds {
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
        } else {
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
