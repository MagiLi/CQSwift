//
//  UIViewController+CQExtension.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/20.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

@objc protocol CQMainNavControllerProtocol {
    @objc optional func navigationShouldPop() -> Bool
}

extension UIViewController: CQMainNavControllerProtocol {
    func navigationShouldPop() -> Bool {
        return true
    }
}

extension UINavigationController: UINavigationBarDelegate, UIGestureRecognizerDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        let vc: UIViewController = topViewController!
        let shouldPop  = vc.navigationShouldPop()
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for subview in navigationBar.subviews {
                if 0.0 < subview.alpha && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25) {
                        subview.alpha = 1.0
                    }
                }
            }
        }
        return false
    }
   
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        } else {
            return topViewController?.navigationShouldPop() ?? true
        }
    }
}
