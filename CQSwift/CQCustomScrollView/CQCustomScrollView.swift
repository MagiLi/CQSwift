//
//  CQCustomScrollView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/7/6.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCustomScrollView: UIView {
    
    var startLocation = CGPoint(x: 0.0, y: 0.0)
    
    var contentSize: CGSize = .zero {
        didSet {
        }
    }
    var contentOffset: CGPoint = .zero {
        didSet {
            var newBounds = self.bounds
            newBounds.origin = contentOffset
            self.bounds = newBounds
        }
    }
    
    
    //MARK: UIPanGestureRecognizer
    @objc fileprivate func panGesture(_ pan:UIPanGestureRecognizer) {
       
        if pan.state == .began {  // 记录每次滑动开始时的初始位置
            self.startLocation = self.bounds.origin
            print("self.startLocation: \(self.startLocation)")
        } else  if pan.state == .changed { // 相对于初始触摸点的偏移量
            let point = pan.translation(in: self)
            print("point: \(point)")
            var  newOriginX = self.startLocation.x - point.x
            var newOriginY = self.startLocation.y - point.y
            
            if (newOriginX < 0) {
                newOriginX = 0
            } else {
               let maxMoveWidth = self.contentSize.width - self.bounds.size.width
               if (newOriginX > maxMoveWidth) {
                   newOriginX = maxMoveWidth;
               }
            }
            if (newOriginY < 0) {
                newOriginY = 0;
            } else {
               let maxMoveHeight = self.contentSize.height - self.bounds.size.height
               if (newOriginY > maxMoveHeight) {
                   newOriginY = maxMoveHeight;
               }
            }
            
            let newOrigin = CGPoint(x: newOriginX, y: newOriginY)
            var newBounds = self.bounds
            newBounds.origin = newOrigin
            self.bounds = newBounds
        }
    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panGesture(_:)))
        self.addGestureRecognizer(pan)
        
        self.backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
