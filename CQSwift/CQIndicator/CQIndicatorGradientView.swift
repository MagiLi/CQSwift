//
//  CQIndicatorGradientView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQIndicatorGradientView: UIView {
    
    fileprivate var timer:Timer?
    
    fileprivate var radius1:CGFloat = 82.0 // 小圆半径
    fileprivate var radius2:CGFloat = 92.0 // 大圆半径
    fileprivate var circleCenter:CGPoint = .zero
    
    fileprivate let maxValue:CGFloat = 1000.0 // 额度最大值1000万
    var currentUserValue:CGFloat = 1000.0 // 当前用户额度
    
    let blankAngle:CGFloat = 110.0 //大圆盘空白的度数
    fileprivate var initRadians:CGFloat!
    fileprivate var initAngle:CGFloat!
    
    var maxRadians:CGFloat! // 当前用户最大的弧度值
    var maxAngle:CGFloat! // 当前用户最大的角度值
    
    var totalRadians:CGFloat! // 大圆盘的总弧度值
    var totalAngle:CGFloat! // 大圆盘的总角度值
    
    var currentRadians:CGFloat! // 当前绘制的弧度值
    var currentAngle:CGFloat! // 当前绘制的角度值
    var count:Int = 0
    
    @objc func update() {
        if self.currentAngle > maxAngle {
            if self.count > 50 {
                self.count = 0
                self.currentAngle = self.initAngle
            } else {
                self.count += 1
                self.currentAngle = self.maxAngle
            }
                
            
            
            // 超出最大值，销毁计时器
            //self.invalidate()
            

        } else {
            let currentRad = self.degreesToRadians(self.currentAngle)
            self.rotateArrow(currentRad)
            self.ringView.rotateRing(self.currentAngle)
            self.currentAngle += 1.0
        }
//        if self.currentRadians > self.maxRadians {
//            // 超出最大值，销毁计时器
//            self.invalidate()
//        } else {
//            self.rotateArrow(self.currentRadians)
//            self.ringView.rotateRing(self.currentRadians)
//            self.currentRadians += 0.01
//        }
    }
    
    //MARK: invalidate
    func invalidate() {
        self.timer?.invalidate()
        self.timer = nil
    }
     
    func rotateArrow(_ radians:CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, radians, 0.0, 0.0, 1.0)
        self.arrowView.layer.transform = transform
    }
    
    //MARK:
    fileprivate func roateView(fromValue:CGFloat, toValue:CGFloat) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = NSNumber(value: fromValue)
        rotationAnimation.toValue = NSNumber(value:toValue)
        rotationAnimation.duration = 2.5
        rotationAnimation.repeatCount = 5.0
//        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        //rotationAnimation.autoreverses = true // 动画完成时原路返回
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        self.arrowView.layer.add(rotationAnimation, forKey: nil)
    }
    
    // 此方法设置重复动画，无法在每一次动画完成后设置时间间隔
    fileprivate func roateRepeatView(fromValue:CGFloat, toValue:CGFloat) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = NSNumber(value: fromValue)
        rotationAnimation.toValue = NSNumber(value:toValue)
        rotationAnimation.duration = 2.5
        rotationAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
//        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        //rotationAnimation.autoreverses = true // 动画完成时原路返回
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        self.arrowView.layer.add(rotationAnimation, forKey: nil)
    }
    
    //MARK: 旋转到初始位置
    fileprivate func roateToInitPosition1() { // 方式一
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = NSNumber(value: 0.0)
        rotationAnimation.toValue = NSNumber(value:self.initRadians)
        rotationAnimation.duration = 0.0
        rotationAnimation.repeatCount = 1
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        self.arrowView.layer.add(rotationAnimation, forKey: nil)
    }
    
    func roateToInitPosition2() { // 方式二
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, self.initRadians, 0.0, 0.0, 1.0)
        self.arrowView.layer.transform = transform
    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initAngle = (180.0 - self.blankAngle) * 0.5 + blankAngle // 初始的度数
        self.initRadians = self.degreesToRadians(initAngle)
        
        self.totalAngle = 360.0 - blankAngle // 大圆盘的总度数
        self.totalRadians = self.degreesToRadians(self.totalAngle)
        
        let angleScale = self.currentUserValue / self.maxValue // 需要旋转的角度比例
        // 当前用户最大的弧度值
        let tempMaxRadians = angleScale * self.totalRadians
        self.maxRadians = tempMaxRadians + self.initRadians
        self.maxAngle = angleScale * self.totalAngle + initAngle
        
        self.currentRadians = self.initRadians
        self.currentAngle = initAngle
        
        self.ringView.startAngle = initAngle
        self.ringView.endAngle = initAngle
        //self.ringView.endAngle = (180.0 - self.blankAngle) * 0.5
        
        self.setupUI()
        
        
       self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        self.roateToInitPosition2()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            //self.roateView(fromValue: self.initRadians, toValue: self.maxRadians)
            //self.ringView.drawRing(fromValue: 0.0, toValue: angleScale)
//            self.roateView(fromValue: self.initRadians, toValue: self.totalRadians + self.initRadians)
//            self.ringView.drawRing(fromValue: 0.0, toValue: 1.0)
        })

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        let bgViewW:CGFloat = self.frame.width
        let bgViewH:CGFloat = bgViewW * 0.824
        let bgViewX = (self.frame.width - bgViewW) * 0.5
        let bgViewY = (self.frame.height - bgViewH) * 0.5
        self.bgView.frame = CGRect(x: bgViewX, y: bgViewY, width: bgViewW, height: bgViewH)
        
        let centerX = bgViewX + bgViewW * 0.5
        let centerY = bgViewY + bgViewH * 0.607
        self.circleCenter = CGPoint(x: centerX, y: centerY)

        let ringViewW = self.radius2 * 2.0
        let ringViewH = ringViewW
        self.ringView.bounds = CGRect(x: 0.0, y: 0.0, width: ringViewW, height: ringViewH)
        self.ringView.center = self.circleCenter
        
        let indicateW:CGFloat = self.radius2 + 20.0
        let indicateH:CGFloat = 50.0
        let indicateX = self.circleCenter.x
        let indicateY = self.circleCenter.y - indicateH * 0.5
        self.arrowView.frame = CGRect(x: indicateX, y: indicateY, width: indicateW, height: indicateH)
        

        let smallCircleW:CGFloat = 80.0
        let smallCircleH:CGFloat = smallCircleW
        let smallCircleX = (self.frame.width - smallCircleW) * 0.5
        let smallCircleY = self.circleCenter.y - smallCircleH * 0.5
        self.smallCircle.frame = CGRect(x: smallCircleX, y: smallCircleY, width: smallCircleW, height: smallCircleH)
    }
    //MARK:setupUI
    func setupUI() {
        
        self.backgroundColor = .lightGray
        self.addSubview(self.bgView) // 背景图
        self.addSubview(self.ringView) // 渐变的圆环
        self.addSubview(self.arrowView) // 箭头
        
        self.addSubview(self.smallCircle) // 中心的小圆

    }
    
    // 将角度转换为弧度
    fileprivate func degreesToRadians(_ angle:CGFloat) -> CGFloat {
        return (.pi * angle) / 180.0
    }
    // 将角度转换为弧度
    fileprivate func radiansToDegrees(_ radians:CGFloat) -> CGFloat {
        return (180.0 * radians) / .pi
    }
    
    //MARK: lazy
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "indicator_bg1000")
        return view
    }()
    lazy var arrowView: CQIGArrowView = {
        let view = CQIGArrowView()
        view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        return view
    }()
    lazy var smallCircle: UIImageView = { // 中间的小圆
        let view = UIImageView()
        view.image = UIImage(named: "indicator_center")
        return view
    }()
    lazy var ringView: CQGradientRingView = {
        let view = CQGradientRingView()
        view.margin = self.radius2 - self.radius1
        return view
    }()
    
}
