//
//  CQMRenderPrimitivesVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/3/22.
//  Copyright © 2023 李超群. All rights reserved.
//

import UIKit
import MetalKit

class CQMRenderPrimitivesVC: UIViewController, MTKViewDelegate {

    var commandQueue:MTLCommandQueue?
    var viewportSize:vector_uint2 = vector_uint2(0, 0)
    
    var pipelineState:MTLRenderPipelineState?
    
    let triangleVertices: [Float] = [
        250.0, -250.0, 0.0, 0.0,  1.0, 0.0, 0.0, 1.0,
        -250.0, -250.0, 0.0, 0.0,  0.0, 1.0, 0.0, 1.0,
        0.0, 250.0, 0.0, 0.0,  0.0, 0.0, 1.0, 1.0
    ]
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
        
        
        guard let lib = mtkView.device?.makeDefaultLibrary() else {
            CQLog("Library 为 nil")
            return
        }
        guard let vertexFunc = lib.makeFunction(name: "vertexShader_RP") else { return }
        guard let fragmentFunc = lib.makeFunction(name: "fragmentShader_RP") else { return }
        
        let pipelineDes = MTLRenderPipelineDescriptor()
        pipelineDes.vertexFunction = vertexFunc
        pipelineDes.fragmentFunction = fragmentFunc
        pipelineDes.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipelineDes.label = "Render Primitives"
        
        do {
            let pso = try mtkView.device?.makeRenderPipelineState(descriptor: pipelineDes)
            self.pipelineState = pso
            
            self.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        } catch let error {
            CQLog(error.localizedDescription)
        }
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
        self.viewportSize.x = UInt32(size.width)
        self.viewportSize.y = UInt32(size.height)
        CQLog("viewportSize: x-\(size.width) y-\(size.height)")
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = self.commandQueue?.makeCommandBuffer() else {
            return
        }
        commandBuffer.label = "Render Primitives"
        guard let passDes = view.currentRenderPassDescriptor else {
            commandBuffer.commit()
            return
        }
        // 修改背景色
        //passDes.colorAttachments[0].clearColor = MTLClearColor(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0)
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDes) else {
            return
        }
        commandEncoder.label = "Render Primitives"
        
        let viewport = MTLViewport(originX: 0.0, originY: 0.0, width: Double(self.viewportSize.x), height: Double(self.viewportSize.y), znear: 0.0, zfar: 1.0)
        commandEncoder.setViewport(viewport)
        commandEncoder.setRenderPipelineState(self.pipelineState!)
        
        let triangleVerticesLength = MemoryLayout<Float>.size * triangleVertices.count
        commandEncoder.setVertexBytes(triangleVertices, length: triangleVerticesLength, index: 0)
        let viewportSizeLength = MemoryLayout<vector_uint2>.size
        commandEncoder.setVertexBytes(&self.viewportSize, length: viewportSizeLength, index: 1)
        
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        commandEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
    
}
