//
//  CQLoadingManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/30.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

enum CQLoadingShowStatus:Int {
    case none = 0 // 没有显示loading
    case showing = 1// 显示中
    case dismissing = 2 // 正在 消失中
}

class CQLoadingManager: NSObject {
    
    static let shared : CQLoadingManager = {
        return CQLoadingManager()
    }()
    
    fileprivate var showTime:Double = 0.0
    var loadingView: CQLoadingView?
    var loadingStatus:CQLoadingShowStatus = .none
    var maskView: UIView?
    
    func show() {
        self.loadingStatus = .showing
        DispatchQueue.main.async {
            self.addLoadingView()
        }
        self.outTimeDismiss()
    }
    
    func dismiss() {
        guard let loadV = self.loadingView else { return }
        self.loadingStatus = .dismissing
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowAnimatedContent, .curveEaseIn, .beginFromCurrentState], animations: {
                loadV.transform = loadV.transform.scaledBy(x: 0.77, y: 0.77)
                loadV.backgroundColor = .clear
            }, completion: { success in
                self.loadingView?.invalidate()
                self.maskView?.removeFromSuperview()
                self.maskView = nil
                self.loadingStatus = .none
            })
        }
    }
    
    fileprivate func addLoadingView() {
        
        if self.maskView != nil { return }
        self.maskView = self.createMaskView()
        let loadingViewW:CGFloat = 85.0
        let loadingViewH:CGFloat = 85.0
        let loadingViewX = (CQScreenW - loadingViewW) * 0.5
        let loadingViewY = (CQScreenH - loadingViewH) * 0.5
        let frame = CGRect(x: loadingViewX, y: loadingViewY, width: loadingViewW, height: loadingViewH)
        self.loadingView = CQLoadingView(frame: frame)
        self.loadingView?.layer.shadowOpacity = 1.0;
        self.loadingView?.layer.shadowColor = UIColor.init(r: 125.0, g: 127.0, b: 135.0, a: 0.15).cgColor
        self.loadingView?.layer.shadowRadius = 10.0
        self.loadingView?.layer.cornerRadius = 5.0
        self.loadingView?.layer.masksToBounds = false
        //        UIApplication.shared.keyWindow?.addSubview(self.loadingView!)
        self.maskView?.addSubview(self.loadingView!)
        let windows = UIApplication.shared.windows
        let firstWindow = windows.first { window in
            return window.isKeyWindow
        }
        firstWindow?.addSubview(self.maskView!)
    }
    
    fileprivate func createMaskView() -> UIView {
        let maskV = UIView(frame: UIScreen.main.bounds)
        return maskV
    }
    fileprivate func outTimeDismiss() {
        self.showTime = Date().timeIntervalSince1970
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 120) {
            let currentTime = Date().timeIntervalSince1970
            if currentTime - self.showTime >= 120 {
                self.dismiss()
            }
        }
    }
}
