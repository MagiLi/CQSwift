//
//  CQMetalSecondController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/10/18.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

class CQMetalSecondController: UIViewController {
    //每一行的前三个分量为顶点坐标，后两个分量为纹理坐标（归一化）UV（U:水平方向，V：垂直方向）
    //需要注意的是：纹理坐标系是左下角为坐标系顶点，而顶点坐标系屏幕中心为顶点
    
    let vertexArrayData: [Float] = [
        //第一个三角形
        -1,   1,    0.0, 0, 0,
        -1,   -1,   0.0, 0, 1,
        1,    -1,   0.0, 1, 1,
        //第二个三角形
        1,    -1,   0.0, 1, 1,
        1,    1,    0.0, 1, 0,
        -1,   1,    0.0, 0, 0
    ]
     /*
               (0,1)
(-1,1)----------------------(1,1)
     |           |          |
     |           |          |
(-1,0)---------(0,0)--------|(1,0)
     |           |          |
     |           |          |
(-1,-1)---------------------(1,-1)
               (0,-1)
     */
    var mtlDevice: MTLDevice?// 1.创建 MTLDevice
    var mtlLayer: CAMetalLayer!// 2.创建 CAMetalLayer
    var mtlCommandQueue: MTLCommandQueue!//3.创建 MTLCommandQueue
    var mtlPipelineDescriptor:MTLRenderPipelineDescriptor!// 渲染管线
    var mtlPipelineState:MTLRenderPipelineState?// 流水线状态
    var mtlTexture: MTLTexture!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMetal()
        
        self.setupPipline()
        self.mtlTexture = self.createImageTexture(UIImage(named: "QR code")!)
        self.render()
    }
    //MARK: setupMetal
    func setupMetal()  {
        self.view.backgroundColor = UIColor.white
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError( "Failed to get the system's default Metal device." )
        }
        mtlDevice = device
        
        mtlLayer = CAMetalLayer()
        mtlLayer.device = mtlDevice
        mtlLayer.pixelFormat = .bgra8Unorm
        mtlLayer.framebufferOnly = true
        mtlLayer.frame = CGRect(x: 50.0, y: 100.0, width: 100.0, height: 100.0)
        self.view.layer.addSublayer(mtlLayer)
    }
    //MARK: 初始化Pipline “流水线,管线”
    func setupPipline() {
        mtlCommandQueue = mtlDevice?.makeCommandQueue()
        
        mtlCommandQueue.label = "main metal command queue"
        
        let mtlDefaultLibrary = mtlDevice?.makeDefaultLibrary()!
        let fragmentProgram = mtlDefaultLibrary?.makeFunction(name: "passThroughFragment")
        let vertexProgram = mtlDefaultLibrary?.makeFunction(name: "passThroughVertex")
        
        mtlPipelineDescriptor = MTLRenderPipelineDescriptor()
        mtlPipelineDescriptor.vertexFunction = vertexProgram
        mtlPipelineDescriptor.fragmentFunction = fragmentProgram;
        mtlPipelineDescriptor.colorAttachments[0].pixelFormat = mtlLayer.pixelFormat
        do {
            try mtlPipelineState = mtlDevice?.makeRenderPipelineState(descriptor: mtlPipelineDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
    }
    //MARK: createImageTexture
    func createImageTexture(_ image: UIImage) -> MTLTexture? {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let width:Int = Int(image.size.width)
        let height:Int = Int(image.size.height)
        let imageData = UnsafeMutableRawPointer.allocate(byteCount: bytesPerPixel * width * height, alignment: 8)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: imageData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerPixel * width, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue)
        
        UIGraphicsPushContext(context!)
        context?.translateBy(x: 0.0, y: CGFloat(height))
        context?.scaleBy(x: 1.0, y: -1.0)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
        UIGraphicsPopContext()
        
        let mtlTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        mtlTextureDescriptor.usage = .shaderRead
        let mtlTexture = self.mtlDevice?.makeTexture(descriptor: mtlTextureDescriptor)
        mtlTexture?.replace(region: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0, withBytes: imageData, bytesPerRow: width * bytesPerPixel)
        return mtlTexture
    }
    //MARK: render
    func render() {
        guard let mtlDrawable = mtlLayer.nextDrawable() else { return }
        let mtlPassDescriptor = MTLRenderPassDescriptor()
        mtlPassDescriptor.colorAttachments[0].texture = mtlDrawable.texture
        mtlPassDescriptor.colorAttachments[0].loadAction = .clear
        mtlPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let mtlCommandBuffer = mtlCommandQueue.makeCommandBuffer()!
        mtlCommandBuffer.label = "Fram command buffer"
        
        //渲染命令编码器
        let mtlCommandEncoder: MTLRenderCommandEncoder = mtlCommandBuffer.makeRenderCommandEncoder(descriptor: mtlPassDescriptor)!
        mtlCommandEncoder.label = "Render Command Encoder"
        mtlCommandEncoder.pushDebugGroup("Brgin draw")
        mtlCommandEncoder.setRenderPipelineState(self.mtlPipelineState!)
        
        //绘制
        self.draw(mtlCommandEncoder, self.mtlTexture)
        
        mtlCommandEncoder.popDebugGroup()
        mtlCommandEncoder.endEncoding()
        mtlCommandBuffer.present(mtlDrawable)// 保证新纹理会在绘制完成后立即出现
        mtlCommandBuffer.commit()// 提交事务(transaction), 把任务交给GPU
    }
    //MARK: draw
    func draw(_ mtlCommandEncoder: MTLRenderCommandEncoder, _ mtlTexture: MTLTexture) {
        let vertexBufferSize = MemoryLayout<Float>.size * self.vertexArrayData.count
        let vertexBuffer = self.mtlDevice?.makeBuffer(bytes: self.vertexArrayData, length: vertexBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        mtlCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        mtlCommandEncoder.setFragmentTexture(mtlTexture, index: 0)
        
        let colors: [Float] = [
            0x2a / 255.0, 0x9c / 255.0, 0x1f / 255.0,
//            0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0,
            0xe6 / 255.0, 0xcd / 255.0, 0x27 / 255.0,
            0xe6 / 255.0, 0x27 / 255.0, 0x57 / 255.0
        ]
        
        let colorsBufferSize = MemoryLayout<Float>.size * colors.count
        let colorsBuffer = self.mtlDevice?.makeBuffer(bytes: colors, length: colorsBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        mtlCommandEncoder.setFragmentBuffer(colorsBuffer, offset: 0, index: 0)
        
        let uniform: [Int] = [colors.count / 3]
        let uniformBufferSize = MemoryLayout<Int>.size * uniform.count
        let uniformBuffer = self.mtlDevice?.makeBuffer(bytes: uniform, length: uniformBufferSize, options: MTLResourceOptions.cpuCacheModeWriteCombined)
        mtlCommandEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)
        
        mtlCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
    }
    
}



