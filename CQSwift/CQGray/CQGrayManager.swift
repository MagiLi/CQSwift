//
//  CQGrayManager.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2022/12/2.
//  Copyright © 2022 yhb. All rights reserved.
//

import UIKit

class CQGrayManager: NSObject {
    
    fileprivate var grayView:CQGrayView?
    //fileprivate var grayView:CQGrayMetalView?
//    fileprivate var grayView:CQGrayOpenGLView?
    
    
    static let shared : CQGrayManager = {
        return CQGrayManager()
    }()
    
    
    func switchFilter(index:Int) {
        //self.grayView?.switchFilter(index: index)
    }
    
    func addGrayView() {
        let grayV = CQGrayView(frame: UIScreen.main.bounds)
        CQKeyWindow?.addSubview(grayV)
        CQKeyWindow?.bringSubviewToFront(grayV)
        self.grayView = grayV

//        let grayV = CQGrayMetalView(frame: UIScreen.main.bounds, device: MTLCreateSystemDefaultDevice())
//        CQKeyWindow?.addSubview(grayV)
//        CQKeyWindow?.bringSubviewToFront(grayV)
//        grayV.frame = UIScreen.main.bounds
//        self.grayView = grayV
        
//        let grayV = CQGrayOpenGLView(frame: UIScreen.main.bounds)
//        CQKeyWindow?.addSubview(grayV)
//        CQKeyWindow?.bringSubviewToFront(grayV)
//        grayV.frame = UIScreen.main.bounds
//        self.grayView = grayV
        
    }
    func removeGrayView() {
        self.grayView?.removeFromSuperview()
        self.grayView = nil
    }
    func bringGrayViewToFront() {
        if let grayView = grayView {
            CQKeyWindow?.bringSubviewToFront(grayView)
        } else {
            self.addGrayView()
        }
    }
}
