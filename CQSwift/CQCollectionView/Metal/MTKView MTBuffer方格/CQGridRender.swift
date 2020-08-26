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
        let vertexData = self.generateVertexData()
        
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
        
        let verticesArrayData: [Float] = [
            //Pixel 位置,   RGBA 颜色
            -20.0, 20.0,   1.0, 0.0, 0.0, 1.0,
            20.0,  20.0,   1.0, 0.0, 0.0, 1.0,
            -20.0,-20.0,   1.0, 0.0, 0.0, 1.0,
            
            20.0, -20.0,   0.0, 0.0, 1.0, 1.0,
            -20.0,-20.0,   0.0, 0.0, 1.0, 1.0,
            20.0,  20.0,   0.0, 0.0, 1.0, 1.0,
        ]
        let stride = 6//步长
        let rowNumber = 25
        let lineNumber = 15
        let spaceGrid:Float = 50.0
//        verticesBufferSize = MemoryLayout<Float>.size * verticesArrayData.count
        //单个四边形顶点数量
        let verticesNumber = verticesArrayData.count / stride
        //整个绘制区域 数据大小 = 单个四边形大小 * 行 * 列
        let floatSize = MemoryLayout<Float>.size
        let singleGridDataSize = floatSize * verticesArrayData.count
        let totalGridDataSize = singleGridDataSize * rowNumber * lineNumber
        let vertexData = NSMutableData(length: totalGridDataSize)

        var currentGrid = vertexData!.mutableBytes

        for rowIndex in 0...rowNumber {
            for lineIndex in 0...lineNumber {
                //计算X,Y位置。注意坐标系基于2D笛卡尔坐标系，中心点(0,0)，所以会出现负数位置。
                //左上角
                var upperLeftPosition:vector_float2!
                upperLeftPosition.x = (-Float(lineNumber) / 2.0 + Float(lineIndex)) * spaceGrid + spaceGrid/2.0
                upperLeftPosition.y = (-Float(rowNumber) / 2.0 + Float(rowIndex)) * spaceGrid + spaceGrid/2.0
                
                
//                memcmp(currentGrid, verticesArrayData, singleGridDataSize)
                
                for vertexIndex in 0...verticesNumber {
                    currentGrid.storeBytes(of: upperLeftPosition.x, toByteOffset: vertexIndex * floatSize, as: Float.self)
                    currentGrid.storeBytes(of: upperLeftPosition.y, toByteOffset: (vertexIndex + 1) * floatSize, as: Float.self)
              //      currentGrid.storeBytes(of: upperLeftPosition.x, as: Float.self)
              
                }
                currentGrid += stride
            }
        }
        
        return vertexData!
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
