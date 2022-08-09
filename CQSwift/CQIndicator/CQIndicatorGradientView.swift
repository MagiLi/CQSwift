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
    var currentValue:CGFloat = 1000 // 当前用户额度
    
    fileprivate var initRadians:CGFloat!
    var currentRadians:CGFloat! // 旋转时的当前弧度值
    var maxRadians:CGFloat! // 当前用户最大的弧度值
    var totalRadians:CGFloat! // 大圆盘的总弧度值
    
    let untilRadians:CGFloat = 0.05 // 每走一次计时器新增的弧度值
    var maxCount:CGFloat = 0.0 // 计时器需要执行的次数
    var ringScale:CGFloat = 0.0 // 渐变圆环渲染的比例（最大值为1.0）
    
    //MARK: invalidate
    func invalidate() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    //MARK: rotateArrow
    @objc func rotateTimer() {
        if self.currentRadians > self.maxRadians {
            // 超出最大值，销毁计时器
            self.invalidate()
        } else {
            self.ringView.animateReset(self.maxCount, scale: self.ringScale)
            self.rotateArrow(self.currentRadians)
            self.currentRadians += self.untilRadians
        }
    }
    
    func rotateArrow(_ radians:CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, radians, 0.0, 0.0, 1.0)
        self.arrowView.layer.transform = transform
    }
    
    //MARK: draw
    override func draw(_ rect: CGRect) {
//        guard let indicatorImg = self.indicatorImg else { return }
//        guard let context = UIGraphicsGetCurrentContext() else { return }
////        var transform = CGAffineTransform(translationX: 0, y: self.bounds.size.height)
////        transform = transform.scaledBy(x: 1.0, y: -1.0)
////        let indicateFrame = tempRect.applying(transform)
//        // 翻转坐标系
//        context.translateBy(x: 0, y: self.bounds.size.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//
//        let indicateFrame = self.getIndicatorFrame()
//        context.draw(indicatorImg.cgImage!, in: indicateFrame)
//        UIGraphicsEndImageContext()
    }
    
//
//    fileprivate func roateView(_ angle:CGFloat) {
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotationAnimation.toValue = NSNumber(value:angle)
//        rotationAnimation.duration = 1
//        rotationAnimation.repeatCount = 1
//        rotationAnimation.fillMode = .forwards
//        rotationAnimation.isRemovedOnCompletion = false
//        //self.arrowView.layer.fillMode = .forwards
//        self.arrowView.layer.add(rotationAnimation, forKey: nil)
//    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        let radians90 = self.degreesToRadians(90) // 90度的弧度值
        self.initRadians = acos(0.5976) + radians90 // 反三角函数求角度（结果是弧度值）
        
        let radians360 = self.degreesToRadians(360)
        self.totalRadians = radians360 - acos(0.5976) * 2.0 // 大圆盘的总弧度值
        
        // 当前用户最大的弧度值
        let tempMaxRadians = self.currentValue / self.maxValue * self.totalRadians
        self.maxRadians = tempMaxRadians + self.initRadians
        self.currentRadians = self.initRadians
        
        self.ringScale = tempMaxRadians / self.totalRadians
        self.maxCount = tempMaxRadians / self.untilRadians // 计算出计时器需要执行的最大次数
        
        self.setupUI()
        
        
        self.ringView.startAngle = self.initRadians
        self.ringView.endAngle = self.totalRadians + self.initRadians

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
        
        self.rotateArrow(self.initRadians)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.rotateTimer), userInfo: nil, repeats: true)
        })
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
        view.image = UIImage(named: "indicator_bg")
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
