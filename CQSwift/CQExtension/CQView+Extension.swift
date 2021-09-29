//
//  CQView+Extension.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/9/29.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit

extension UIView {
    
    func shakeUnlockTips() { // 手势解锁震动提示
        let position = self.layer.position
        let left = CGPoint(x: position.x - 10.0, y: position.y)
        let right = CGPoint(x: position.x + 10.0, y: position.y)
        let animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = NSValue(cgPoint: left)
        animation.toValue = NSValue(cgPoint: right)
        animation.autoreverses = true
        animation.duration = 0.08
        animation.repeatCount = 3
        self.layer.add(animation, forKey: nil)
    }
    
}
