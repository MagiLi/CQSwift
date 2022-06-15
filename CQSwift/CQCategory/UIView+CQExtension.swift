//
//  UIView+Extension.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/23.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

extension UIView {
    //MARK:截屏
    func snapshotFullScreenView() -> UIView {
        return self.snapshotView(afterScreenUpdates: true) ?? UIView()
    }
    func snapshotScreenView() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: ctx)
        self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return image
    }
    func snapshotLongView() -> UIImage? {
        if self.isKind(of: UIScrollView.self) == true {
            let shadowView = self as! UIScrollView
            UIGraphicsBeginImageContextWithOptions(shadowView.contentSize, false, 0.0);
            let saveContentOffset = shadowView.contentOffset// 保存现在视图的位置偏移信息
            let saveFrame = shadowView.frame// 保存现在视图的frame信息
            shadowView.contentOffset = CGPoint.zero// 把要截图的视图偏移量设置为0
            shadowView.frame = CGRect(x: 0.0, y: 0.0, width: shadowView.contentSize.width, height: shadowView.contentSize.height)
            
            guard let ctx = UIGraphicsGetCurrentContext() else {return nil}
            shadowView.layer.render(in: ctx)
            shadowView.drawHierarchy(in: shadowView.frame, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            shadowView.contentOffset = saveContentOffset;
            shadowView.frame = saveFrame;
            // 保存相册
//            UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
            return image
        } else {
            return self.snapshotScreenView()
        }
    }
    // 把某个未显示到屏幕上的view绘成图片
    func drawToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    // 给控件设置添加圆角
    func radiousLayer(cornerRadius: CGFloat)  -> CAShapeLayer{
        let maskPath = UIBezierPath(roundedRect: self.frame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.frame;
        maskLayer.path = maskPath.cgPath
        return maskLayer
    }
     
    // 获取最后一个Window
    func lastWindow() -> UIWindow {
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows.reversed() {
            if window.isKind(of: UIWindow.self) && window.bounds.equalTo(UIScreen.main.bounds) {
                return window
            }
        }
        return UIApplication.shared.keyWindow!
    }
    
    /**
     *  自定义一个view的时候和父控制器隔了几层，需要刷新或者对父控制器做出一些列修改，
     *  这时候可以使用响应者连直接拿到父控制器，避免使用多重block嵌套或者通知这种情况
     */
    func topViewControllerTest() -> UIViewController? {
        var viewController: UIViewController?
        var next = self.superview
        while next != nil {
            let nextResponder: UIResponder = (next?.next)!
            if nextResponder.isKind(of: UIViewController.self) {
                viewController = nextResponder as? UIViewController
                break
            }
            next = next?.superview
        }
        return viewController
    }
    
    func topViewController()  -> UIViewController? {
        var viewController: UIViewController?
        var next = self.next
        while next != nil {
            if next!.isKind(of: UIViewController.classForCoder()) {
                viewController = next as? UIViewController
                break
            }
            next = next!.next
        }
        return viewController
    }
}

// MARK: - 快速从XIB创建一个View (仅限于XIB中只有一个View的时候)
extension UIView {
    class func loadViewFromXib1<T>() -> T {
        let fullViewName: String = NSStringFromClass(self.classForCoder())
        let viewName: String = fullViewName.components(separatedBy: ".").last!
        return Bundle.main.loadNibNamed(viewName, owner: nil, options: nil)?.last! as! T
    }
}
