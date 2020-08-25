//
//  CQMTBufferGridVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/8/25.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit
import MetalKit

class CQMTBufferGridVC: UIViewController {

    var mtkView: MTKView!
    var render: CQGridRender!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mtkView = MTKView()
        self.mtkView.device = MTLCreateSystemDefaultDevice()
        self.mtkView.colorPixelFormat = .rgba8Unorm
        if self.mtkView.device == nil {
            debugPrint("Device is nil!")
            return
        }
        self.view.addSubview(self.mtkView)
        
        self.render = CQGridRender(mtkView: self.mtkView)
        self.mtkView.delegate = self.render
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mtkView?.frame = self.view.frame
    }

}
