//
//  UIView+CQFrame.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/15.
//  Copyright © 2022 李超群. All rights reserved.
//

import Foundation

extension UIView {
    /** 控件底部 */
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }set {
            var newframe = self.frame;
            newframe.origin.y = newValue - self.frame.size.height;
            self.frame = newframe;
        }
    }
    
     /** 控件顶部 */
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }set {
            var newframe = self.frame;
            newframe.origin.y = newValue
            self.frame = newframe;
        }
    }
    
    /** 控件左边 */
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }set {
            var newframe = self.frame;
            newframe.origin.x = newValue
            self.frame = newframe;
        }
    }
    
    
    /**  控件右边 */
    var right: CGFloat! {
        get {
            return self.frame.origin.x + self.frame.size.width
        }set {
            var newframe = self.frame;
            newframe.origin.x = newValue - self.frame.size.width
            self.frame = newframe;
        }
    }
    
    /** origin的X */
    var cq_x: CGFloat! {
        get {
            return self.frame.origin.x
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newValue
            frame                 = tmpFrame
        }
    }
    
    /** origin的Y */
    var cq_y: CGFloat! {
        get {
            return self.frame.origin.y
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newValue
            frame                 = tmpFrame
        }
    }
    
    /** 中心点的X */
    var cq_center: CGPoint {
        get {
            return center
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter               = newValue
            center                  = tmpCenter
        }
    }

    
    /** 中心点的X */
    var cq_centerX: CGFloat! {
        get {
            return self.center.x
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter.x             = newValue
            center                  = tmpCenter
        }
    }
    
    /** 中心点的Y */
    var cq_centerY: CGFloat! {
        get {
            return self.center.y
        }
        set {
            var tmpCenter : CGPoint = center
            tmpCenter.y             = newValue
            center                  = tmpCenter
        }
    }
    
    /** 控件的宽度 */
    var cq_width: CGFloat! {
        get {
            return self.frame.size.width
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newValue
            frame                 = tmpFrame
        }
    }

    /** 控件的高度 */
    var cq_height: CGFloat! {
        get {
            return self.frame.size.height
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newValue
            frame                 = tmpFrame
        }
    }
    
    /** 控件的尺寸 */
    var cq_size: CGSize! {
        get {
            return self.frame.size
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.size         = newValue
            frame                 = tmpFrame
        }
    }
    
    /** 控件的origin */
    var cq_origin: CGPoint! {
        get {
        return self.frame.origin
        }
        set {
            var tmpFrame : CGRect = frame
            tmpFrame.origin       = newValue
            frame                 = tmpFrame
        }
    }
    
    var cq_rect: CGRect! {
        return self.frame
    }
    
    /// MARK: - Layer相关属性方法圆角方法
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get{
            return self.layer.borderWidth
        } set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get{
            return UIColor(cgColor: self.layer.borderColor!)
        }set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get{
            return self.layer.shadowOffset
        } set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get{
            return UIColor(cgColor: self.layer.shadowColor!)
        } set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get{
            return self.layer.shadowRadius
        }set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get{
            return self.layer.shadowOpacity
        }set {
            self.layer.shadowOpacity = newValue
        }
    }
}
