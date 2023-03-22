//
//  CQMCalculattionsVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/3/22.
//  Copyright © 2023 李超群. All rights reserved.
//

import UIKit

class CQMCalculationsVC: UIViewController {

    let arrayLength:Int = 1 << 10
    var bufferSize:Int = 0
    // Float占4个字节，所以步长为4
    let stepLength = MemoryLayout<Float>.size
    
//    let arrayLength:Int = 4
//    let bufferSize:Int = MemoryLayout<Float>.size * (4)
    
    var device:MTLDevice?
    var computePSO:MTLComputePipelineState?
    var commandQueue:MTLCommandQueue?
    
    var bufferA:MTLBuffer?
    var bufferB:MTLBuffer?
    var bufferR:MTLBuffer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 设置配置
        var success = self.setConfigure()
        if !success { return }
        // 2. 设置Buffer数据
        success = self.setBufferData()
        if !success { return }
        // 3. 命令编码
        success = self.commandEncode()
        if !success { return }
        // 4. 验证结果（GPU和CPU计算的结果是否一致）
        self.verifyResults()
    }
    
    // return：true设置配置成功
    func setConfigure() -> Bool {
        // 1.1 获取device
        guard let device = MTLCreateSystemDefaultDevice() else {
            CQLog("获取 device 失败")
            return false
        }
        
        self.device = device
        
        // 1.2 获取Library(metal文件库)
        guard let lib = device.makeDefaultLibrary() else {
            CQLog("获取 Library 失败")
            return false
        }
        guard let arrayAddFunc = lib.makeFunction(name: "array_add") else {
            CQLog("获取 array_add 函数 失败")
            return false
        }
        
        // 1.3 创建PSO（管道状态对象）
        do {
            let computePSO = try device.makeComputePipelineState(function: arrayAddFunc)
            self.computePSO = computePSO
        } catch let error {
            CQLog("创建 PSO  失败: \(error.localizedDescription)")
            return false
        }
       
        return true
    }
    
    func setBufferData() -> Bool {
        // 2.1 计算buffer字节数
        self.bufferSize = stepLength * arrayLength
        
        // 2.2 创建Buffer
        guard let bufferA = self.device?.makeBuffer(length: bufferSize),
                    let bufferB = self.device?.makeBuffer(length: bufferSize),
                    let bufferR = self.device?.makeBuffer(length: bufferSize) else {
            CQLog("创建 buffer 失败")
            return false
        }
        self.bufferA = bufferA
        self.bufferB = bufferB
        self.bufferR = bufferR
        
        // 2.3 生成随机数
        self.generateRandomBuffer(self.bufferA!)
        //self.readRandomBuffer(self.bufferA!)
        self.generateRandomBuffer(self.bufferB!)
        //self.readRandomBuffer(self.bufferB!)
        return true
    }
    
    func commandEncode() -> Bool {
        // 3.1 创建命令队列
        guard let queue = self.device!.makeCommandQueue() else {
            CQLog("创建 commandQueue 失败")
            return false
        }
        self.commandQueue = queue
        // 3.2 创建命令缓冲区
        guard let commandBuffer = queue.makeCommandBuffer() else {
            CQLog("创建 commandBuffer 失败")
            return false
        }
        // 3.3 创建命令编码器
        guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
            CQLog("创建 commandEncoder 失败")
            return false
        }
        
        // 3.4 设置管道状态和参数
        commandEncoder.setComputePipelineState(self.computePSO!)
        commandEncoder.setBuffer(self.bufferA, offset: 0, index: 0)
        commandEncoder.setBuffer(self.bufferB, offset: 0, index: 1)
        commandEncoder.setBuffer(self.bufferR, offset: 0, index: 2)
        
        // 3.5 设置线程组
        let threads = MTLSize(width: arrayLength, height: 1, depth: 1)
        var maxThreadgroupSize = self.computePSO!.maxTotalThreadsPerThreadgroup
        if maxThreadgroupSize > arrayLength {
            maxThreadgroupSize = arrayLength
        }
        let threadgroupSize = MTLSize(width: maxThreadgroupSize, height: 1, depth: 1)
        commandEncoder.dispatchThreads(threads, threadsPerThreadgroup: threadgroupSize)
        
        // 3.6 结束编码、提交命令
        commandEncoder.endEncoding()
        commandBuffer.commit()
        
        commandBuffer.waitUntilCompleted()
//        commandBuffer.addCompletedHandler { commandBuffer in
//
//        }
        return true
    }
    
    func verifyResults() {
        let a = self.bufferA!.contents()
        let b = self.bufferB!.contents()
        let result = self.bufferR!.contents()

        for i in 0..<arrayLength {
            let aF = a.load(fromByteOffset: i * self.stepLength, as: Float.self)
            let bF = b.load(fromByteOffset: i * self.stepLength, as: Float.self)
            let resultF = result.load(fromByteOffset: i * self.stepLength, as: Float.self)
            if resultF != (aF + bF) {
                CQLog("Compute ERROR: index=\(i) result=\(resultF) vs \(aF + bF)=a+b\n")
                assert(resultF == (aF + bF))
            }
        }
        CQLog("Compute results as expected\n")
    }
    
    //MARK: 指针的存储操作(指定步长4字节， float占4个字节)
    func generateRandomBuffer(_ buffer:MTLBuffer) {
        let dataPtr = buffer.contents()
        for i in 0..<arrayLength {
            let random = Float(Float(arc4random()) / Float(0xFFFFFFFF))
            dataPtr.storeBytes(of: random, toByteOffset: i * self.stepLength, as: Float.self)
            //dataPtr.advanced(by: i * 4).storeBytes(of: random, as: Float.self)
            //CQLog("index:\(i) value:\(random)")
        }
    }
    func readRandomBuffer(_ buffer:MTLBuffer) {
        let dataPtr = buffer.contents()
        for i in 0..<arrayLength {
            let value = dataPtr.load(fromByteOffset: i * self.stepLength, as: Float.self)
            //let value = dataPtr.advanced(by: i * 4).load(as: Float.self)
            //CQLog("output-index:\(i) value:\(value)")
        }
    }
}
