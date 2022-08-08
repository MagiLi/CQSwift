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
        var rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value:angle)
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = 10
        self.indicatorView.layer.add(rotationAnimation, forKey: nil)
    }
//    - (void)rotateView:(UIImageView *)view{
//
//        CABasicAnimation *rotationAnimation;
//
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//
//        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
//
//        rotationAnimation.duration = 1;
//
//        rotationAnimation.repeatCount = HUGE_VALF;
//
//        [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//
//    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.roateView(-.pi * 0.5)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleCenter = CGPoint(x: self.frame.width * 0.5, y:  self.frame.height * 0.5)
        self.indicatorSize = CGSize(width: 10.0, height: self.radius)
        let indicateX = self.circleCenter.x - self.indicatorSize.width * 0.5
        let indicateY = self.circleCenter.y - self.radius
        self.indicatorView.frame = CGRect(x: indicateX, y: indicateY, width: self.indicatorSize.width, height: self.indicatorSize.height)
    }
    //MARK:setupUI
    func setupUI() {
        self.backgroundColor = .lightGray
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(rotate), userInfo: nil, repeats: true)
        
        self.addSubview(self.indicatorView)
    }
    //MARK:lazy
    lazy var indicatorView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "indicator")
        return view
    }()
}
