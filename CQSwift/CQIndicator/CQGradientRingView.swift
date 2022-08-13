//
//  CQGradientRingView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQGradientRingView: UIView {
    fileprivate let lineWidth1:CGFloat = 30.0
    fileprivate let lineWidth2:CGFloat = 3.0
    var margin:CGFloat = 0.0 // 两个圆之间的距离
    var startAngle:CGFloat = 0.0
    var endAngle:CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        let centerX = rect.width * 0.5
        let centerY =  rect.height * 0.5
        let lineR = centerX - self.lineWidth2 - 2.0 // 外侧圆环的半径
        let smallR = centerX - self.margin - self.lineWidth1 * 0.5 // 内侧圆环的半径
        
        let centerPoint = CGPoint(x: centerX, y: centerY) // 圆心
        
        //贝塞尔曲线画圆弧  
        let startAngle = 149.0 / 180.0 * .pi // 度数转角度
        let endAngle = 31.0 / 180.0 * .pi
        // 内侧圆环的path
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: smallR, startAngle: startAngle, endAngle: endAngle, clockwise: true)
         
//        self.bgLayer.path = circlePath.cgPath
        self.shapeLayer.path = circlePath.cgPath
        self.gradientLayer.mask = self.shapeLayer
        
        // 外侧圆环的path
        let linePath = UIBezierPath(arcCenter: centerPoint, radius: lineR, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.lineShapeLayer.path = linePath.cgPath
        self.lineGradientLayer.mask = self.lineShapeLayer
    }
    
//    func animateReset(_ count:CGFloat, scale:CGFloat) {
//        var tempScale = scale
//        if scale > 1.0 {
//            tempScale = 1.0
//        } else if scale < 0.0 {
//            tempScale = 0.0
//        }
//
//        if(self.shapeLayer.strokeEnd <= tempScale){
//            let untilValue = tempScale / count
//            self.shapeLayer.strokeEnd += untilValue
//            self.lineShapeLayer.strokeEnd += untilValue
//        }else{ }
//    }
    
    func drawRing(fromValue:CGFloat, toValue:CGFloat) {
        let rotationAnimation = CABasicAnimation(keyPath: "strokeEnd")
        rotationAnimation.fromValue = NSNumber(value: fromValue)
        rotationAnimation.toValue = NSNumber(value:toValue)
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = 1
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        //self.arrowView.layer.fillMode = .forwards
        self.shapeLayer.add(rotationAnimation, forKey: nil)
        self.lineShapeLayer.add(rotationAnimation, forKey: nil)
    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.bgLayer.frame = self.bounds
        
        // 外侧圆环
        self.lineShapeLayer.frame = self.bounds
        self.lineGradientLayer.frame = self.bounds
        
        
//        // 内侧圆环
//        let smallX:CGFloat = self.margin
//        let smallY:CGFloat = self.margin
//        let smallW:CGFloat = self.bounds.width - smallX * 2.0
//        let smallH:CGFloat = self.bounds.height - smallY * 2.0
//        let smallFrame = CGRect(x: smallX, y: smallY, width: smallW, height: smallH)
        
        self.shapeLayer.frame =  self.bounds
        self.gradientLayer.frame =  self.bounds
       
        let leftW = self.bounds.width / 2.0
        let leftH = self.bounds.height
        self.leftGradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: leftW, height: leftH)
        self.rightGradientLayer.frame = CGRect(x: self.leftGradientLayer.frame.maxX, y: 0.0, width: leftW, height: leftH)
    }
    //MARK:setupUI
    func setupUI() {
//        self.backgroundColor = UIColor(r: 0.0, g: 0.0, b: 0.0, a: 0.3)
//        self.layer.addSublayer(self.bgLayer)
        
        // 内侧侧圆环
        self.layer.addSublayer(self.shapeLayer)
        self.gradientLayer.addSublayer(self.leftGradientLayer)
        self.gradientLayer.addSublayer(self.rightGradientLayer)
        self.layer.addSublayer(self.gradientLayer)
        
        // 外侧圆环
        self.layer.addSublayer(self.lineShapeLayer)
        self.layer.addSublayer(self.lineGradientLayer)
    }
    //MARK:lazy
//    lazy var bgLayer: CAShapeLayer = {
//        let bgLayer = CAShapeLayer()
//        bgLayer.fillColor = UIColor.clear.cgColor //填充色 -  透明
//        bgLayer.lineWidth1 = self.lineWidth1
//        bgLayer.strokeColor = UIColor.clear.cgColor //线条颜色
//        bgLayer.strokeStart = 0 //起始点
//        bgLayer.strokeEnd = 1//终点
//        bgLayer.lineCap = .round //让线两端是圆滑的状态
//        return bgLayer
//    }()
    lazy var lineShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = self.lineWidth2
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 0.0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.blue.cgColor
        return layer
    }()
    lazy var lineGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        //设渐变颜色
        let leftColor1 = UIColor(r: 255.0, g: 255.0, b: 255.0, a: 0.1).cgColor
        //let leftColor2 = UIColor(r: 255.0, g: 255.0/2.0, b: 0.0, a: 0.5).cgColor
        let leftColor2 = UIColor(r: 255.0, g: 255.0, b: 255.0, a: 1.0).cgColor
        layer.colors = [leftColor1, leftColor2]
        //这里设置渐变色渐变范围 0到1就是整个leftGradientLayer上都在渐变
        layer.locations = [NSNumber(value: 0), NSNumber(value: 0.8)]
        //下面这两个就是渐变色方向Y越大就是越下面 所以是从下到上从黄到红渐变
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = self.lineWidth1
        //layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 0.0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.blue.cgColor
        return layer
    }()
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    
    lazy var leftGradientLayer: CAGradientLayer = {
        // 渐变图层
        let leftGradientLayer = CAGradientLayer()
        //设渐变颜色
        let leftColor1 = UIColor(r: 255.0, g: 255.0/2.0, b: 0.0, a: 0.1).cgColor
        //let leftColor2 = UIColor(r: 255.0, g: 255.0/2.0, b: 0.0, a: 0.5).cgColor
        let leftColor2 = UIColor(r: 255.0, g: 255.0, b: 0.0, a: 0.3).cgColor
        leftGradientLayer.colors = [leftColor1, leftColor2]
        //这里设置渐变色渐变范围 0到1就是整个leftGradientLayer上都在渐变
        leftGradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 0.8)]
        //下面这两个就是渐变色方向Y越大就是越下面 所以是从下到上从黄到红渐变
        leftGradientLayer.startPoint = CGPoint(x: 0, y: 1)
        leftGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        return leftGradientLayer
    }()
    
    lazy var rightGradientLayer: CAGradientLayer = {
        let rightGradientLayer = CAGradientLayer()
 
//        let rightColor1 = UIColor(r: 255.0, g: 255.0/2.0, b: 0.0, a: 0.5).cgColor
        
//        let rightColor2 = UIColor(r: 255.0, g: 169.0, b: 35.0, a: 1.0).cgColor
        let rightColor1 = UIColor(r: 255.0, g: 255.0, b: 0.0, a: 0.3).cgColor
        let rightColor2 = UIColor(r: 255.0, g: 255.0, b: 0.0, a: 0.6).cgColor
        rightGradientLayer.colors = [rightColor1, rightColor2]
        rightGradientLayer.locations = [NSNumber(value: 0.2), NSNumber(value: 1)]
        rightGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        rightGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return rightGradientLayer
    }()
}
