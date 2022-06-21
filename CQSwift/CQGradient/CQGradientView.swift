//
//  CQGradientView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/21.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQGradientView: UIView {

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        /*
         指定渐变色
         space:颜色空间
         components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
         如果有三个颜色则这个数组有4*3个元素
         locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
         count:渐变个数，等于locations的个数
         */
           //创建一个RGB的颜色空间
           let rgb = CGColorSpaceCreateDeviceRGB()
           //定义渐变颜色数组
        let colors:[CGFloat] = [
            0.0, 0.0, 0.0, 0.3,
            0.0, 0.0, 0.0, 0.1,
            0.0, 0.0, 0.0, 0.3
        ]
        
        let locations:[CGFloat] = [0.0, 0.5, 1.0]
        let gradient = CGGradient(colorSpace: rgb, colorComponents: colors, locations: locations, count: locations.count) 

        /*
         绘制线性渐变
         context:图形上下文
         gradient:渐变色
         startPoint:起始位置
         endPoint:终止位置
         options:绘制方式,DrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
         DrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
         */
        let start = CGPoint(x: 0.0, y: 0.0)
        let end = CGPoint(x: self.bounds.width, y: self.bounds.height)
        ctx?.drawLinearGradient(gradient!, start: start, end: end, options: .drawsAfterEndLocation)
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
    }
    //MARK:setupUI
    func setupUI() {
        self.backgroundColor = .clear
    }
    //MARK:lazy
}
