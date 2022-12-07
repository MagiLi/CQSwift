//
//  CQGrayMetalView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/12/5.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit
import MetalKit

class CQGrayMetalView: MTKView, MTKViewDelegate {
    
    var commandQueue: MTLCommandQueue? // 
    var pipelineState: MTLRenderPipelineState? // 渲染管道
//    var viewportSize:vector_uint2?
    
    //MARK: MTKViewDelegate
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
//        self.viewportSize?.x = UInt32(size.width)
//        self.viewportSize?.y = UInt32(size.height)
    }

    let vertexArrayData: [Float] = [
        0.5, -0.25, 0.0, 1.0,   0.3, 0.59, 0.11, 1.0,
        -0.5, -0.25, 0.0, 1.0,   0.3, 0.59, 0.11, 1.0,
        -0.0, 0.25, 0.0, 1.0,   0.3, 0.59, 0.11, 1.0
    ]
    func draw(in view: MTKView) {
        //1.创建命令缓冲区
        guard let commandBuffer = self.commandQueue?.makeCommandBuffer() else {
            debugPrint("Make command buffer failed!")
            return
        }
        commandBuffer.label = "MyCommand"
        
        //2.获取当前渲染过程描述符
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            debugPrint("Get current render pass descriptor failed!")
            return
        }
        //3.创建命令编码器
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            debugPrint("Make command encoder failed!")
            return
        }
        commandEncoder.label = "MyRenderCommandEncoder"
        //4.设置视口（可绘制区域）
//        let viewportSizeX = self.viewportSize?.x ?? UInt32(CQScreenW)
//        let viewportSizeY = self.viewportSize?.y ?? UInt32(CQScreenH)
//        let viewPort = MTLViewport(originX: 0.0, originY: 0.0, width: Double(viewportSizeX), height: Double(viewportSizeY), znear: -1.0, zfar: 1.0)
//        commandEncoder.setViewport(viewPort)
        //5.设置当前渲染管道状态对象
        commandEncoder.setRenderPipelineState(self.pipelineState!)
        //6.设置顶点数据
        //从应用程序代码中发送数据给Metal顶点着色器 函数
        //顶点数据+颜色数据
        //   1) 指向要传递给着色器的内存的指针
        //   2) 我们想要传递的数据的内存大小
        //   3)一个整数索引，它对应于我们的“vertexShader”函数中的缓冲区属性限定符的索引。
        let vertexBufferSize = MemoryLayout<Float>.size * self.vertexArrayData.count
        commandEncoder.setVertexBytes(vertexArrayData, length:vertexBufferSize, index: 0)
        //7.设置适口
//        let viewportSizeL = MemoryLayout<uint>.size * 2
//        commandEncoder.setVertexBytes(&viewportSize, length: viewportSizeL, index: 1)
        //8.绘制
        // @method drawPrimitives:vertexStart:vertexCount:
        //@brief 在不使用索引列表的情况下,绘制图元
        //@param 绘制图形组装的基元类型
        //@param 从哪个位置数据开始绘制,一般为0
        //@param 每个图元的顶点个数,绘制的图型顶点数量
        /*
         MTLPrimitiveTypePoint = 0, 点
         MTLPrimitiveTypeLine = 1, 线段
         MTLPrimitiveTypeLineStrip = 2, 线环
         MTLPrimitiveTypeTriangle = 3,  三角形
         MTLPrimitiveTypeTriangleStrip = 4, 三角型扇
         */
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        //9.表示该编码器生成的命令都已完成,并且从NTLCommandBuffer中分离
        commandEncoder.endEncoding()
        //10.一旦框架缓冲区完成，使用当前可绘制的进度表
        commandBuffer.present(view.currentDrawable!)
        //11.完成渲染并将命令缓冲区推送到GPU
        commandBuffer.commit()
    }
    //MARK: init
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        self.device = device //1.获取device
        if self.device == nil {
            debugPrint("Device is nil!")
            return
        }
        self.delegate = self
        //vec3(0.3, 0.59, 0.11)
        //dot(<#T##lhs: simd_quatd##simd_quatd#>, <#T##rhs: simd_quatd##simd_quatd#>)
        self.setupMetal()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 设置metal
    fileprivate func setupMetal() {
        //2.加载着色器文件
        let library = self.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader_gray")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader_gray")
        
        //3.创建渲染管线描述符（渲染管道解释器）
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        //renderPipelineDescriptor.label = "Simple Pipeline"
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        //一组存储颜色数据的组件
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        //renderPipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.bgra8Unorm
        //4.创建渲染管线状态对象（渲染管道）
        do {
            self.pipelineState = try self.device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            debugPrint("渲染管道：pipelineState error")
        }
        
        self.commandQueue = self.device?.makeCommandQueue()
    }
    
    //MARK: hit
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}
