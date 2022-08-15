//
//  CQIndicatorView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/8.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQIndicatorView: UIView {
    
    fileprivate var timer:Timer?
    fileprivate var indicatorSize:CGSize = .zero
    fileprivate var radius:CGFloat = 160.0
    fileprivate var circleCenter:CGPoint = .zero
    
    //MARK: invalidate
    func invalidate() {
        self.timer?.invalidate()
        self.timer = nil
    }
    //MARK: rotate
    @objc func rotate() {

    }
    

    
    //MARK: draw
    override func draw(_ rect: CGRect) {
//        guard let indicatorImg = self.indicatorImg else { return }
//        guard let context = UIGraphicsGetCurrentContext() else { return }
////        var transform = CGAffineTransform(translationX: 0, y: self.bounds.size.height)
////        transform = transform.scaledBy(x: 1.0, y: -1.0)
//
//        context.translateBy(x: 0, y: self.bounds.size.height)
//        context.scaleBy(x: 1.0, y: -1.0)
//
//        let indicateFrame = self.getIndicatorFrame()
////        let indicateFrame = tempRect.applying(transform)
//        context.draw(indicatorImg.cgImage!, in: indicateFrame)
//        UIGraphicsEndImageContext()
    }
    fileprivate func getIndicatorFrame() -> CGRect {
        let indicateX = self.circleCenter.x - self.indicatorSize.width * 0.5
        let indicateY = self.circleCenter.y - self.radius
        return CGRect(x: indicateX, y: indicateY, width: self.indicatorSize.width, height: self.indicatorSize.height)
    }
    
    fileprivate func calculateIndicatorPoint(_ angle:CGFloat) {
        let tempAngle = .pi * 2.0 - angle
        let centerX = self.radius * cos(tempAngle)
        let centerY = self.radius * sin(tempAngle)
        let x1 = self.circleCenter.x + centerX
        let y1 = self.circleCenter.y - centerY
        //点A
        let A_dx = centerY / self.radius * self.indicatorSize.width * 0.5
        let A_x = x1 - A_dx
        let A_dy = centerX / self.radius * self.indicatorSize.width * 0.5
        let A_y = y1 + A_dy
        let pointA = CGPoint(x: A_x, y: A_y)
        // 点B
        let B_x = x1 + A_dx
        let B_y = y1 - A_dy
        let pointB = CGPoint(x: B_x, y: B_y)
        // 点C
        let C_dx = centerX / self.radius * self.indicatorSize.height
        let C_x = A_x + C_dx
        let C_dy = centerY / self.radius * self.indicatorSize.height
        let C_y = A_y + C_dy
        let pointC = CGPoint(x: C_x, y: C_y)
        
        // 点D
        let D_dx = C_dx
        let D_x = B_x + D_dx
        let D_dy = C_dy
        let D_y = B_y + D_dy
        let pointD = CGPoint(x: D_x, y: D_y)
//        return CGRect(x: x1, y: y1, width: self.indicatorSize.width, height: self.indicatorSize.height)
    }
    
    fileprivate func roateView(_ angle:CGFloat) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value:angle)
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = 3
        rotationAnimation.fillMode = .forwards
        rotationAnimation.isRemovedOnCompletion = false
        //self.indicatorView.layer.fillMode = .forwards
        self.indicatorView.layer.add(rotationAnimation, forKey: nil)
    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.roateView(.pi)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        let bgViewW:CGFloat = self.frame.width
        let bgViewH:CGFloat = bgViewW * 0.77
        let bgViewX = (self.frame.width - bgViewW) * 0.5
        let bgViewY = (self.frame.height - bgViewH) * 0.5
        self.bgView.frame = CGRect(x: bgViewX, y: bgViewY, width: bgViewW, height: bgViewH)
        
        let centerX = bgViewX + bgViewW * 0.5
        let centerY = bgViewY + bgViewH * 0.6541
        self.circleCenter = CGPoint(x: centerX, y: centerY)
        self.indicatorSize = CGSize(width: self.radius, height: 10.0)
        let indicateX = self.circleCenter.x -  self.indicatorSize.width
        let indicateY = self.circleCenter.y - self.indicatorSize.height * 0.5
        self.indicatorView.frame = CGRect(x: indicateX, y: indicateY, width: self.indicatorSize.width, height: self.indicatorSize.height)
    }
    //MARK:setupUI
    func setupUI() {
        self.backgroundColor = .lightGray
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(rotate), userInfo: nil, repeats: true)
        self.addSubview(self.bgView)
        self.addSubview(self.indicatorView)
    }
    
    // 将角度转换为弧度
    fileprivate func degreesToRadians(_ angle:CGFloat) -> CGFloat {
        return (.pi * angle) / 180.0
    }
    
    //MARK: lazy
    lazy var bgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "indicator_bg")
        return view
    }()
    lazy var indicatorView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "indicator_h")
        view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        let radians = self.degreesToRadians(-40)
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, radians, 0.0, 0.0, 1.0)
        view.layer.transform = transform
        return view
    }()
    
//    lazy var totalQuotaView: <#type name#> = {
//        <#statements#>
//        return <#value#>
//    }()
}
