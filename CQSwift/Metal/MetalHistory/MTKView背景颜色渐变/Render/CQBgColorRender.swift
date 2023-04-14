//
//  CQBgColorRender.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/8/20.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit
import MetalKit

struct CQColor {
    let red, green, blue, alpha : Double
}

class CQBgColorRender: NSObject, MTKViewDelegate {
    var device: MTLDevice?
    //所有应用程序需要与GPU交互的第一个对象，是一个对象MTLCommandQueue.
    //使用MTLCommandQueue 去创建对象，并且加入MTLCommandBuffer 对象中。
    //确保它们能够按照正确顺序发送到GPU。对于每一帧，一个新的MTLCommandBuffer 对象创建并且填满了由GPU执行的命令.
    var commandQueue: MTLCommandQueue? 
    var growing = true//1. 增加颜色/减小颜色的 标记
    var primaryChannel = 0//2.颜色通道值(0~3)
    var colorChannels:[Double] = [1.0, 0.0, 0.0, 1.0]//3.颜色通道数组colorChannels(颜色值)
    let DynamicColorRate:Double = 0.015;//4.颜色调整步长
    //MARK: MTKViewDelegate
    //当MTKView视图发生大小改变时调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    //每当视图需要渲染时调用
    func draw(in view: MTKView) {
        let color = self.makeFancyColor()
        view.clearColor = MTLClearColorMake(color.red, color.green, color.blue, color.alpha)
        
        guard let commandBuffer = self.commandQueue?.makeCommandBuffer() else {
            debugPrint("Make CommandBuffe failed!")
            return
        }
        
        commandBuffer.label = "MyCommand"
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else {
            debugPrint("Get current render pass descriptor failed!")
            return
        }
        //通过渲染描述符renderPassDescriptor创建MTLRenderCommandEncoder 对象
        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            debugPrint("Make render command encoder failed!")
            return
        }
        renderCommandEncoder.label = "MyRenderCommandEncoder"
        renderCommandEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            debugPrint("Get current drawable failed!")
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    //MAKE: makeFancyColor
    fileprivate func makeFancyColor() -> CQColor {
        
        if growing {
            //动态信道索引 (1,2,3,0)通道间切换
            let dynamicChannelIndex = (primaryChannel + 1) % 3
            colorChannels[dynamicChannelIndex] += DynamicColorRate
            if(colorChannels[dynamicChannelIndex] >= 1.0) {
                growing = false
                
                //将颜色通道修改为动态颜色通道
                primaryChannel = dynamicChannelIndex
            }
        } else {
            //获取动态颜色通道
            let dynamicChannelIndex = (primaryChannel + 2) % 3
            colorChannels[dynamicChannelIndex] -= DynamicColorRate
            if(colorChannels[dynamicChannelIndex] <= 0.0) {
                //又调整为颜色增加
                growing = true
            }
        }
        
        return CQColor(red: colorChannels[0], green: colorChannels[1], blue: colorChannels[2], alpha: colorChannels[3])
    }
    
    convenience init(mtkView: MTKView) {
        self.init()
        
        self.device = mtkView.device
        self.commandQueue = self.device?.makeCommandQueue()
    }
    
}
