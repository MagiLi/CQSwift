//
//  CQGradientRingView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQGradientRingView: UIView {
    let lineWidth:CGFloat = 30.0
     
    override func draw(_ rect: CGRect) {
        let centerX = rect.width * 0.5
        let centerY = centerX
        let r = centerX - self.lineWidth * 0.5
        let centerPoint = CGPoint(x: centerX, y: centerY)
        //贝塞尔曲线画圆弧
        let startAngle = .pi * 3.0 / 4.0
        let endAngle = .pi / 4.0
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: true)
         
        self.bgLayer.path = circlePath.cgPath
        self.shapeLayer.path = circlePath.cgPath
        self.gradientLayer.mask = self.shapeLayer
    }
    
    func animateReset() {
        if(self.shapeLayer.strokeEnd > 0){
            self.shapeLayer.strokeEnd -= 0.01
        }else{ }
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
        self.bgLayer.frame = self.bounds
        self.shapeLayer.frame = self.bounds
        self.gradientLayer.frame = self.bounds
        
        let leftW = self.bounds.width / 2.0
        let leftH = self.bounds.height
        self.leftGradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: leftW, height: leftH)
        self.rightGradientLayer.frame = CGRect(x: self.leftGradientLayer.frame.maxX, y: 0.0, width: leftW, height: leftH)
    }
    //MARK:setupUI
    func setupUI() {
        //self.backgroundColor = .cyan
        self.layer.addSublayer(self.bgLayer)
        self.layer.addSublayer(self.shapeLayer)
        self.gradientLayer.addSublayer(self.leftGradientLayer)
        self.gradientLayer.addSublayer(self.rightGradientLayer)
        self.layer.addSublayer(self.gradientLayer)
    }
    //MARK:lazy
    lazy var bgLayer: CAShapeLayer = {
        let bgLayer = CAShapeLayer()
        bgLayer.fillColor = UIColor.clear.cgColor //填充色 -  透明
        bgLayer.lineWidth = self.lineWidth
        bgLayer.strokeColor = UIColor.clear.cgColor //线条颜色
        bgLayer.strokeStart = 0 //起始点
        bgLayer.strokeEnd = 1//终点
        bgLayer.lineCap = .round //让线两端是圆滑的状态
        return bgLayer
    }()
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = self.lineWidth
        //layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 1.0
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
