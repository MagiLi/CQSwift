//
//  CQLoadingView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/5/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

enum CQAnimateStatus:Int {
    case onlyRoate_0 = 0 // 首次只旋转，不放大也不缩小 (暂用周期比例：0.23)
    case narrow_1 = 1 // 缩小状态 (暂用周期比例：0.28)
    case suspend_2 = 2 // 暂停状态 (暂用周期比例：0.14)
    case enlarge_3 = 3 // 放大状态 (暂用周期比例：0.23)
    case onlyRoate_4 = 4 // 第二次只旋转，不放大也不缩小 (暂用周期比例：0.12)
    case suspend_5 = 5 // 暂停状态 (暂用周期比例：0.14)
}

class CQLoadingView: UIView {

    var timer:Timer?
    
    let singleCycleTime:CGFloat = 1.2 // 旋转360度的时间(不包含暂停时间)
    fileprivate var duration_suspend_2:CGFloat = 0.14 // 暂停的时间
    fileprivate var duration_suspend_5:CGFloat = 0.28 // 暂停的时间
    // 每种状态旋转的角度
    fileprivate var angle_onlyRoate_0:CGFloat = .pi * 2.0 * 0.32
    fileprivate var angle_narrow_1:CGFloat = .pi * 2.0 * 0.27
    fileprivate var angle_enlarge_3:CGFloat = .pi * 2.0 * 0.27
    fileprivate var angle_onlyRoate_4:CGFloat = .pi * 2.0 * 0.14
    
    
    let repeatDuration:CGFloat = 0.01 // 计时器的重复的间隔时间
    var repeatCount:Int = 0 // 旋转360度计时器执行的次数
    
    let minIntervalRadian:CGFloat = 20.0 / 180.0 * .pi // 弧线之间最小的间隔 弧度值(20度)
    let maxIntervalRadian:CGFloat = 88.0 / 180.0 * .pi // 弧线之间最大的间隔 弧度值(88度)
    var currentIntervalRadian:CGFloat = 20.0 / 180.0 * .pi // 当前间隔弧度
    var unitRadian_narrow_1:CGFloat = 0.0 // 计时器执行1次, 当前间隔弧度值 增加的 弧度值
    var unitRadian_enlarge_3:CGFloat = 0.0 // 计时器执行1次, 当前间隔弧度值 减少的 弧度值

    var count_suspend_5:Int = 0 // suspend_5状态暂停执行repeatRotate方法的次数
    var currentCount_suspend_5:Int = 0 // suspend_5当前时间已经暂停几次
    var count_suspend_2:Int = 0 // suspend_2状态暂停执行repeatRotate方法的次数
    var currentCount_suspend_2:Int = 0 // suspend_2当前时间已经暂停几次
    var currentAnimateStatus:CQAnimateStatus = .onlyRoate_0 // 当前动画状态
    
    /*旋转*/
    var currentRoate:CGFloat = 0.0 // 当前旋转的弧度
    var unitRoate:CGFloat = 0.0 // 计时器执行1次, 当前旋转的弧度 (增加/减少的 弧度值)
    
    //MARK:
    @objc func repeatRotate() {
        if self.currentAnimateStatus == .onlyRoate_0 { // 只旋转，不放大也不缩小
            self.currentIntervalRadian = minIntervalRadian
            self.currentRoate = self.currentRoate + self.unitRoate // 增加旋转弧度
            
            if self.currentRoate >= self.angle_onlyRoate_0 {
                self.currentAnimateStatus = .narrow_1
            }
            self.setNeedsDisplay()
        } else if self.currentAnimateStatus == .narrow_1 { // 缩小动画，扩大空白面积
            self.currentIntervalRadian = self.currentIntervalRadian + self.unitRadian_narrow_1
            self.currentRoate = self.currentRoate + self.unitRoate
            if self.currentRoate >= (self.angle_narrow_1 + self.angle_onlyRoate_0) {
                self.currentIntervalRadian = maxIntervalRadian
                self.currentAnimateStatus = .suspend_2
            }
            self.setNeedsDisplay()
        } else if self.currentAnimateStatus == .suspend_2 {
            self.currentCount_suspend_2 = self.currentCount_suspend_2 + 1
            if self.currentCount_suspend_2 >= self.count_suspend_2 {
                self.currentCount_suspend_2 = 0 // 暂停次数归零
                self.currentAnimateStatus = .enlarge_3
            } else {
                // 此时应该处于暂停状态
            }
        } else if self.currentAnimateStatus == .enlarge_3 { // 扩大动画，缩小空白面积
            self.currentIntervalRadian = self.currentIntervalRadian - self.unitRadian_enlarge_3
            self.currentRoate = self.currentRoate + self.unitRoate
            if self.currentRoate >= (self.angle_enlarge_3 + self.angle_narrow_1 + self.angle_onlyRoate_0) {
                self.currentIntervalRadian = minIntervalRadian
                self.currentAnimateStatus = .onlyRoate_4
            }
            self.setNeedsDisplay()
        } else if self.currentAnimateStatus == .onlyRoate_4 { // 只旋转，不放大也不缩小
            self.currentIntervalRadian = minIntervalRadian
            self.currentRoate = self.currentRoate + self.unitRoate // 增加旋转弧度
            if self.currentRoate >= (self.angle_onlyRoate_4 + self.angle_enlarge_3 + self.angle_narrow_1 + self.angle_onlyRoate_0) {
                self.currentRoate = 0.0
                self.currentAnimateStatus = .suspend_5
            }
            self.setNeedsDisplay()
        } else if self.currentAnimateStatus == .suspend_5 {
            self.currentCount_suspend_5 = self.currentCount_suspend_5 + 1
            if self.currentCount_suspend_5 >= self.count_suspend_5 {
                self.currentCount_suspend_5 = 0 // 暂停次数归零
                self.currentAnimateStatus = .onlyRoate_0
            } else {
                // 此时应该处于暂停状态
            }
        }
     
    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        let angle2P = .pi * 2.0
        self.repeatCount = Int(self.singleCycleTime / self.repeatDuration)
        self.count_suspend_2 = Int(self.duration_suspend_2 / self.repeatDuration)
        self.count_suspend_5 = Int(self.duration_suspend_5 / self.repeatDuration)
        
        let intervalRadian = self.maxIntervalRadian - self.minIntervalRadian
        // 缩小时执行的次数、每次缩小的弧度值
        let scale_narrow_1 = self.angle_narrow_1 / angle2P
        let repeatCount_narrow_1 = scale_narrow_1 * CGFloat(self.repeatCount)
        self.unitRadian_narrow_1 = intervalRadian / repeatCount_narrow_1
        // 放大时执行的次数、每次放大的弧度值
        let scale_enlarge_3 = self.angle_enlarge_3 / angle2P
        let repeatCount_enlarge_3 = scale_enlarge_3 * CGFloat(self.repeatCount)
        self.unitRadian_enlarge_3 = intervalRadian / repeatCount_enlarge_3
        
        self.unitRoate = angle2P / Double(self.repeatCount)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     顺时针方向：
                        3π/2
                            |
                            |
             π ——— | ——— 0, 2π
                            |
                            |
                          π/2
     */
    override func draw(_ rect: CGRect) {
        // 起始/结束弧度位置  注意: 起始与结束这里是弧度
        let angle1:CGFloat = 0.0 + self.currentRoate
        let angle2:CGFloat = .pi * 0.5 - self.currentIntervalRadian + self.currentRoate
        self.drawCircle(rect, angle1, angle2) // 0-90度的弧度
        let angle3:CGFloat = .pi * 0.5 + self.currentRoate
        let angle4:CGFloat = .pi - self.currentIntervalRadian + self.currentRoate
        self.drawCircle(rect, angle3, angle4) // 90-180度的弧度
        let angle5:CGFloat = .pi + self.currentRoate
        let angle6:CGFloat = .pi * 1.5 - self.currentIntervalRadian + self.currentRoate
        self.drawCircle(rect, angle5, angle6) // 180-270度的弧度
        let angle7:CGFloat = .pi * 1.5 + self.currentRoate
        let angle8:CGFloat = .pi * 2.0 - self.currentIntervalRadian + self.currentRoate
        self.drawCircle(rect, angle7, angle8) // 270-360度的弧度
    }
    func drawCircle(_ rect: CGRect, _ startAngle:CGFloat, _ endAngle:CGFloat) {
        // arcCenter: 圆心, radius: 半径, clockwise: 绘制方向， 顺时针方向为true
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let path1 = UIBezierPath.init(arcCenter: center, radius: 14.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path1.lineWidth = 2.0
        path1.lineCapStyle = .round
        UIColor.black.setStroke()
        path1.stroke()
    }
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK:setupUI
    func setupUI() {
        self.timer = Timer.scheduledTimer(timeInterval: self.repeatDuration, target: self, selector: #selector(repeatRotate), userInfo: nil, repeats: true)
    }
    //MARK:lazy

    deinit {
        print("CQLoadingView deinit")
    }
}
