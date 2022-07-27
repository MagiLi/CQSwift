/*
 * 减速动画参数
 */

import Foundation
import CoreGraphics

public struct DecelerationTimingParameters {
    public var initialValue: CGPoint // 初始位置
    public var initialVelocity: CGPoint // 初始速度
    public var decelerationRate: CGFloat // 测测额度
    public var threshold: CGFloat // 确定衰减时间的阈值
    
    public init(initialValue: CGPoint, initialVelocity: CGPoint, decelerationRate: CGFloat, threshold: CGFloat) {
        assert(decelerationRate > 0 && decelerationRate < 1)
        
        self.initialValue = initialValue
        self.initialVelocity = initialVelocity
        self.decelerationRate = decelerationRate
        self.threshold = threshold
    }
}

public extension DecelerationTimingParameters {
    // 衰减滚动停止的点
    var destination: CGPoint {
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue - initialVelocity / dCoeff
    }
    // 衰减动画时间
    var duration: TimeInterval {
        guard initialVelocity.length > 0 else { return 0 }
        
        let dCoeff = 1000 * log(decelerationRate)
        return TimeInterval(log(-dCoeff * threshold / initialVelocity.length) / dCoeff)
    }
    // 运动方程
    func value(at time: TimeInterval) -> CGPoint {
        let dCoeff = 1000 * log(decelerationRate)
        return initialValue + (pow(decelerationRate, CGFloat(1000 * time)) - 1) / dCoeff * initialVelocity
    }
    // 越界之前的动画时间
    func duration(to value: CGPoint) -> TimeInterval? {
        // 为什么要这个判断，加上后计算不准确，不加有可能闪退
        //guard value.distance(toSegment: (initialValue, destination)) < threshold else { return nil }
        
        let dCoeff = 1000 * log(decelerationRate)
        return TimeInterval(log(1.0 + dCoeff * (value - initialValue).length / initialVelocity.length) / dCoeff)
    }
    // 越界瞬间的动画速度
    func velocity(at time: TimeInterval) -> CGPoint {
        return initialVelocity * pow(decelerationRate, CGFloat(1000 * time))
    }
    
    // 以恒定速率减速至零速度后行驶的距离。
    // Distance travelled after decelerating to zero velocity at a constant rate.
    // initialVelocity:手势的初始速度 decelerationRate:衰减率
    func project(initialVelocity: Float, decelerationRate: Float) -> Float {
        return (initialVelocity / 1000.0) * decelerationRate / (1.0 - decelerationRate)
    }
}
