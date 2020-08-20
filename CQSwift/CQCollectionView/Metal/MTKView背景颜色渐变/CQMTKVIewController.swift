//
//  CQMTKVIewController.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/8/20.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit
import MetalKit

class CQMTKVIewController: UIViewController {

    var mtkView: MTKView!
    var render: CQBgColorRender!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mtkView = MTKView()
        self.mtkView.device = MTLCreateSystemDefaultDevice()
        if self.mtkView.device == nil {
            debugPrint("Device is nil!")
            return
        }
        self.mtkView.preferredFramesPerSecond = 60
        let render = CQBgColorRender(mtkView: self.mtkView)
        self.mtkView.delegate = render
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mtkView.frame = self.view.frame
    }
    
}
