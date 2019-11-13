//
//  CQMetalFirstController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/10/18.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class CQMetalFirstController: UIViewController {
    // 1、MTLDevice, 你可以把一个MTLDevice想象成是你和CPU的直接连接。
        //你将通过使用MTLDevice创建所有其他你需要的Metal对象（像是command queues，buffers，textures）。
        //2 创建一个CAMetalLayer
        //3 创建一个Vertex Buffer
        var vertexBuffer: MTLBuffer!
        // 3.1 在CPU创建一个浮点数数组，需要通过把它移动到一个MTLBuffer，来发送这些数据到GPU。
        let vertexData:[Float] = [
             0.0,  1.0, 0.0,
            -1.0, -1.0, 0.0,
             1.0, -1.0, 0.0
        ]
        //4 创建一个Vertex Shader
        //5 创建一个Fragment Shader
        // 6、创建一个Render Pipeline
        //7 创建一个Command Queue
        //把这个想象成是一个列表装载着你告诉GPU一次要执行的命令。
        var commandQueue: MTLCommandQueue!
        
        //MARK: 渲染三角形
        // 8、创建一个Display Link
        var timer: CADisplayLink!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.white
            guard let mtlDevice = MTLCreateSystemDefaultDevice() else {
                fatalError( "Failed to get the system's default Metal device." )
            }
            let mtlLayer:CAMetalLayer! = CAMetalLayer()
            // 2.0 必须明确layer使用的MTLDevice，简单地设置早前获取的device
            mtlLayer.device = mtlDevice
            // 2.1 把像素格式（pixel format）设置为BGRA8Unorm，它代表"8字节代表蓝色、绿色、红色和透明度，通过在0到1之间单位化的值来表示"。这次两种用在CAMetalLayer的像素格式之一，一般情况下你这样写就可以了。
            mtlLayer.pixelFormat = .bgra8Unorm
            // 2.2 苹果鼓励将framebufferOnly设置为true，来增强表现效率。除非你需要对从layer生成的纹理（textures）取样，或者你需要在layer绘图纹理(drawable textures)激活一些计算内核，否则你不需要设置。（大部分情况下你不用设置）
            mtlLayer.framebufferOnly = true
            // 2.3 把layer的frame设置为view的frame
            mtlLayer.frame = view.layer.frame
            var drawableSize = self.view.bounds.size
            drawableSize.width *= self.view.contentScaleFactor
            drawableSize.height *= self.view.contentScaleFactor
            mtlLayer.drawableSize = drawableSize
            self.view.layer.addSublayer(mtlLayer)
            // 3.2 获取vertex data的字节大小。你通过把元素的大小和数组元素个数相乘来得到
            let dataSize = vertexData.count * 4
            // 3.3 在GPU创建一个新的buffer，从CPU里输送data
            vertexBuffer = mtlDevice.makeBuffer(bytes: vertexData, length: dataSize, options: MTLResourceOptions(rawValue: UInt(0)))
            
            // 6.1 通过调用device.newDefaultLibrary
            //方法获得的MTLibrary对象访问到你项目中的预编译shaders,然后通过名字检索每个shader
            let defaultLibrary = mtlDevice.makeDefaultLibrary()
            let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
            let vertextProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
            // 6.2 这里设置你的render pipeline。
            //它包含你想要使用的shaders、颜色附件（color attachment）的像素格式(pixel format)。（例如：你渲染到的输入缓冲区，也就是CAMetalLayer）
            let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
            pipelineStateDescriptor.vertexFunction = vertextProgram
            pipelineStateDescriptor.fragmentFunction = fragmentProgram
            pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            var pipelineState: MTLRenderPipelineState!
            do {
                pipelineState = try mtlDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
            } catch  {
                print("error")
            }
            // 7.1 初始化commandQueue
            commandQueue = mtlDevice.makeCommandQueue()
            
            //MARK: 渲染三角形
            // 8.1 初始化 timer，设置timer，让它每次刷新屏幕的时候调用一个名叫drawloop的方法
    //        timer = CADisplayLink(target: self, selector: #selector(drawloop))
    //        timer.add(to: RunLoop.main, forMode: .default)
            
            // metal layer上调用nextDrawable() ，它会返回你需要绘制到屏幕上的纹理(texture)
            let drawable = mtlLayer.nextDrawable()
            // 9、创建一个Render Pass Descriptor，配置什么纹理会被渲染到、clear color，以及其他的配置
            let renderPassDesciptor = MTLRenderPassDescriptor()
            renderPassDesciptor.colorAttachments[0].texture = drawable?.texture
            // 设置load action为clear，也就是说在绘制之前，把纹理清空
            renderPassDesciptor.colorAttachments[0].loadAction = .clear
            // 绘制的背景颜色设置为绿色
            renderPassDesciptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.8, 0.5, 1.0)
            
            // 10、创建一个Command Buffer
            // 你可以把它想象为一系列这一帧想要执行的渲染命令。注意在你提交command buffer之前，没有事情会真正发生，这样给你对事物在何时发生有一个很好的控制。
            let commandBuffer:MTLCommandBuffer! = commandQueue.makeCommandBuffer()
            
            // 11、创建一个渲染命令编码器(Render Command Encoder)
            // 创建一个command encoder，并指定你之前创建的pipeline和顶点
            let renderEncoder:MTLRenderCommandEncoder! = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDesciptor)
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            /*
             绘制图形
             - parameter type:          画三角形
             - parameter vertexStart:   从vertex buffer 下标为0的顶点开始
             - parameter vertexCount:   顶点数
             - parameter instanceCount: 总共有1个三角形
            */
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
              
            // 完成后，调用endEncoding()
            renderEncoder.endEncoding()
            
            // 保证新纹理会在绘制完成后立即出现
            commandBuffer.present(drawable!)
            // 提交事务(transaction), 把任务交给GPU
            commandBuffer.commit()

        }
        //MARK: drawloop
        @objc func drawloop() {
            self.render()
        }
        func render() {
               //TODO
        }
}
