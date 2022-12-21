//
//  CQGrayView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/12/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQGrayView: UIView {
// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIColorDodgeBlendMode
//    CIAdditionCompositing
//    CIColorBlendMode
//    CIColorBurnBlendMode
//    CIColorDodgeBlendMode
//    CIDarkenBlendMode
//    CIDifferenceBlendMode
//    CIDivideBlendMode
//    CIExclusionBlendMode
//    CIHardLightBlendMode
//    CIHueBlendMode
//    CILightenBlendMode
    
//    CILinearBurnBlendMode
//    CILinearDodgeBlendMode
//    CILuminosityBlendMode
//    CIMaximumCompositing
//    CIMinimumCompositing
//    CIMultiplyBlendMode
//    CIMultiplyCompositing
//    CIOverlayBlendMode
//    CIPinLightBlendMode
//    CISaturationBlendMode
//    CIScreenBlendMode
//    CISoftLightBlendMode
//    CISourceAtopCompositing
//    CISourceInCompositing
//    CISourceOutCompositing
//    CISourceOverCompositing
//    CISubtractBlendMode

    //MARK: 切换滤镜
    func switchFilter(index:Int) {
        switch index {
        case 0:
            // 此过滤器通常用于添加高光和镜头光斑效果。明亮效果
            self.layer.compositingFilter = "additionCompositing"
        case 1:
            // 此模式保留图像中的灰度级。
            self.layer.compositingFilter = "colorBlendMode"
        case 2:
            // 使背景图像样本变暗以反映源图像样本。
            // 指定白色的源图像采样值不会产生更改。
            self.layer.compositingFilter = "colorBurnBlendMode"
        case 3:
            // 使背景图像样本变亮以反映源图像样本。
            // 指定黑色的源图像采样值不会产生更改。
            self.layer.compositingFilter = "colorDodgeBlendMode"
        case 4:
            // 通过选择较暗的样本（从源图像或背景）创建合成图像样本。
            // 结果是背景图像样本被较暗的源图像样本替换。
            self.layer.compositingFilter = "darkenBlendMode"
        case 5:
            // 从背景图像采样颜色中减去源图像采样颜色，或减去相反的颜色，具体取决于哪个采样具有更大的亮度值。
            // 黑色的源图像采样值不会产生变化；白色反转背景颜色值。
            self.layer.compositingFilter = "differenceBlendMode"
        case 6:
            // 将背景图像样本颜色与源图像样本颜色分开。
            self.layer.compositingFilter = "divideBlendMode"
        case 7:
            // 黑色的源图像采样值不会产生变化；白色反转背景颜色值。
            self.layer.compositingFilter = "exclusionBlendMode"
        case 8:
            // 根据源图像样本颜色，可以相乘或屏蔽颜色。
            self.layer.compositingFilter = "hardLightBlendMode"
        case 9:
            // 使用背景图像的亮度和饱和度值与输入图像的色调。
            self.layer.compositingFilter = "hueBlendMode"
        case 10:
            // 通过选择较亮的样本（从源图像或背景）创建合成图像样本。
            self.layer.compositingFilter = "lightenBlendMode"
        case 11:
            // 根据背景颜色，将输入图像样本与背景图像样本相乘或屏蔽。
            self.layer.compositingFilter = "overlayBlendMode"
        default:
            self.layer.compositingFilter = "saturationBlendMode"
            
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: setupUI
    func setupUI() {
        self.isUserInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .gray
        // 灰度
        // 没有饱和度的背景区域（即纯灰色区域）不会产生变化。
        self.layer.compositingFilter = "saturationBlendMode"
        
//        self.backgroundColor = .black
//        self.layer.compositingFilter = "colorBlendMode"
    }
    
    //MARK: lazy
}
