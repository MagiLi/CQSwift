//
//  CQMTTriangleVC.swift
//  CQSwift
//
//  Created by 李超群 on 2020/8/22.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit
import MetalKit

class CQMTTriangleVC: UIViewController {
    
    var mtkView: MTKView!
    var render: CQTriangleRender!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mtkView = MTKView()
        self.mtkView.device = MTLCreateSystemDefaultDevice()
        if self.mtkView.device == nil {
            debugPrint("Device is nil!")
            return
        }
        self.mtkView.preferredFramesPerSecond = 60
        self.render = CQTriangleRender(mtkView: self.mtkView)
//        self.render.mtkView(self.mtkView, drawableSizeWillChange: self.mtkView.drawableSize)
        self.mtkView.delegate = self.render
        self.view.addSubview(self.mtkView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mtkView.frame = self.view.frame
    }

}
