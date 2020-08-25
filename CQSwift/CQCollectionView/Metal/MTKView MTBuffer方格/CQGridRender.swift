//
//  CQGridRender.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/8/25.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit
import MetalKit

class CQGridRender: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var mtlBuffer:MTLBuffer!
    var vertexNumber:NSInteger!
    
    let vertexArrayData: [Float] = [
        //Pixel 位置,   RGBA 颜色
        -20.0, 20.0,   1.0, 0.0, 0.0, 1.0,
        20.0,  20.0,   1.0, 0.0, 0.0, 1.0,
        -20.0,-20.0,   1.0, 0.0, 0.0, 1.0,
        
        20.0, -20.0,   0.0, 0.0, 1.0, 1.0,
        -20.0,-20.0,   0.0, 0.0, 1.0, 1.0,
        20.0,  20.0,   0.0, 0.0, 1.0, 1.0,
    ]
    
    //MARK: MTKViewDelegate
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    func draw(in view: MTKView) {
        
    }
    //MARLLK:
    fileprivate func loadMetal(_ mtkView: MTKView) {
        //1.加载所有的.metal文件
        guard let library = self.device.makeDefaultLibrary() else {
            debugPrint("Make Default Library failed!")
            return
        }
        //2.加载着色器函数
        let vertexFunction = library.makeFunction(name: "vertexShaderGrid")
        let fragmentFunction = library.makeFunction(name: "fragmentShaderGrid")
        
        //3.创建渲染管道描述符
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.label = "GridRenderPipelineDescriptor"
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        
        //4.创建渲染管道状态
        do {
            self.pipelineState = try self.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            debugPrint("Make pipeline state failed!")
            return
        }
        
        //5.生成顶点数据
        let vertexData = NSData()
        
        //6.创建顶点缓存区
        guard let buffer = self.device.makeBuffer(length: vertexData.length, options: .storageModeShared) else {
            debugPrint("Make MTLBuffer failde!")
            return
        }
        self.mtlBuffer = buffer
        
        /*
        memcpy(void *dst, const void *src, size_t n);
        dst:目的地
        src:源内容
        n: 长度
        */
        //复制vertexData到mtlBuffer
        memcmp(self.mtlBuffer.contents(), vertexData.bytes, vertexData.length)
//        let size
//        self.vertexNumber = vertexData.length /
        
    }
    fileprivate func generateVertexData() -> NSData {
        
        return NSData()
    }
    //MARK: init
    convenience init(mtkView: MTKView) {
        self.init()
        
        guard let myDevice = mtkView.device else {
            debugPrint("Device is nil!")
            return
        }
        self.device = myDevice
        
        self.loadMetal(mtkView)
    }
}
