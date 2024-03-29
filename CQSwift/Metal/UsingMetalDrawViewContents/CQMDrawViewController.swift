//
//  CQMDrawViewController.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/3/22.
//  Copyright © 2023 李超群. All rights reserved.
//

import UIKit
import MetalKit

class CQMDrawViewController: UIViewController, MTKViewDelegate {

    //var mtkView:MTKView?
    var commandQueue:MTLCommandQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mtkView = self.view as? MTKView else {
            CQLog("mtkView 为 nil")
            return
        }
        
    
        guard let commandQueue = mtkView.device?.makeCommandQueue() else {
            CQLog("commandQueue 为 nil")
            return
        }
        self.commandQueue = commandQueue
       
       
        
        self.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
    }
    
    override func loadView() {
        let view = MTKView()
        view.enableSetNeedsDisplay = true
        view.clearColor = MTLClearColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
        view.device = MTLCreateSystemDefaultDevice()
        view.delegate = self
        self.view = view
    }

    
    //MARK: MTKViewDelegate
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        CQLog("draw draw draw")
        guard let commandBuffer = self.commandQueue?.makeCommandBuffer() else {
            CQLog("commandBuffer 为 nil")
            return
        }
        
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            CQLog("renderPassDescriptor 为 nil")
            return
        }
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            CQLog("commandEncoder 为 nil")
            return
        }
        
        commandEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
