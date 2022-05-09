//
//  CQLoadingView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/5/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQLoadingView: UIView {

    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        // 圆心
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // 半径
        let radius:CGFloat = 30.0
        // 起始/结束弧度位置  注意: 起始与结束这里是弧度
        let startAngle:CGFloat = 0.0
        let endAngle:Double = .pi / 2
        // 绘制方向， 顺时针方向为true
        let clockwise = true
        let path1 = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        path1.lineWidth = 3.0
        path1.lineCapStyle = .round
        UIColor.black.set()
//        path1.fill()
        path1.stroke()
    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK:setupUI
    func setupUI() {
        
    }
    //MARK:lazy

}
