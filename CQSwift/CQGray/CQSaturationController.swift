//
//  CQSaturationController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/12/7.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

typealias colorG = (r:Double, g:Double, b:Double)

class CQSaturationController: UIViewController {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imgView.frame = self.view.bounds
        self.filterView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(self.imgView)
//        self.view.addSubview(self.filterView)
        
        let bgColor_red = 255.0/255.0
        let bgColor_green = 0.0/255.0
        let bgColor_blue = 0.0/255.0
        let bgColor:colorG = (r:bgColor_red, g:bgColor_green, b:bgColor_blue)
        let color_red = 142.0/255.0
        let color_green = 142.0/255.0
        let color_blue = 142.0/255.0
        let sourceColor:colorG = (r:color_red, g:color_green, b:color_blue)
        
        // use background color
        let lum = self.lumFunc(bgColor:bgColor)
        // use source color
        let sat = max(max(color_red, color_green), color_blue) - min(min(color_red, color_green), color_blue)
        // setSat
        let setSat:colorG = self.setSatFunc(bgColor, sat)
        // setLum
        let resultColor = self.setSatLumFunc(color: setSat, lum: lum)
        
        self.filterView.backgroundColor = UIColor(red: resultColor.r, green: resultColor.g, blue: resultColor.b, alpha: 1.0 )
    }
    
    func setSatLumFunc(color:colorG, lum:Double) -> colorG {
        let d = lum - self.lumFunc(bgColor: color)
        let red = color.r + d
        let green = color.g + d
        let blue = color.b + d
        return self.clipColorFunc(color: (r:red, g:green, b:blue))
    }

    func clipColorFunc(color:colorG) -> colorG {
        let l = self.lumFunc(bgColor: color)
        let n = min(min(color.r, color.g), color.b)
        let x = max(max(color.r, color.g), color.b)
        var red = color.r
        var green = color.g
        var blue = color.b
//        if n < 0.0 {
//            red = l + (red - 1) * l / (l - n)
//            green = 1 + (green - 1) * l / (l - n)
//            blue = l + (blue - 1) * l / (l - n)
//        }
//        if x > 1.0 {
//            red = l + (red - 1) * (l - 1) / (x - l)
//            green = 1 + (green - 1) * (l - 1) / (x - l)
//            blue = l + (blue - 1) * (l - 1) / (x - 1)
//        }
        if n < 0.0 {
            red = l + (red - l) * l / (l - n)
            green = l + (green - l) * l / (l - n)
            blue = l + (blue - l) * l / (l - n)
        }
        if x > 1.0 {
            red = l + (red - l) * (1 - l) / (x - l)
            green = l + (green - l) * (1 - l) / (x - l)
            blue = l + (blue - l) * (1 - l) / (x - l)
        }
        return (r: red, g: green, b:blue)
    }
    func setSatFunc(_ bgColor:colorG, _ sat:Double) -> colorG {
        
        var bgRed = 0.0
        var bgGreen = 0.0
        var bgBlue = 0.0
        let equal1 = bgColor.r == bgColor.g
        let equal2 = bgColor.r == bgColor.b
        if equal1 && equal2 { // r、g、相等
            return (r:bgRed, g:bgGreen, b:bgBlue)
        }
        else {
            if bgColor.r > bgColor.g {
                if bgColor.r > bgColor.b { // r为最大值
                    if bgColor.g > bgColor.b { // r > g > b
                        bgGreen = ((bgColor.g - bgColor.b) * sat)/(bgColor.r - bgColor.b)
                    } else if bgColor.g > bgColor.b { // r > b > g
                        bgBlue = ((bgColor.b - bgColor.g) * sat)/(bgColor.r - bgColor.g)
                    } else { // r > g = b
                        bgBlue = 0.0
                    }
                    bgRed = sat // 最大值设为 sat
                }
                else if bgColor.r < bgColor.b { // b> r > g
                    bgRed = ((bgColor.r - bgColor.g) * sat)/(bgColor.b - bgColor.g)
                    bgBlue = sat // 最大值设为 sat
                }
                else { // r==b > g
                    //bgBlue = ((bgColor.b - bgColor.g) * sat)/(bgColor.r - bgColor.g)
                    bgBlue = 0.0
                    bgRed = sat // 最大值设为 sat
                }
            }
            else if bgColor.r < bgColor.g { // g > r > b
                bgRed = ((bgColor.r - bgColor.b) * sat)/(bgColor.r - bgColor.b)
                bgGreen = sat // 最大值设为 sat
            }
            else { // r = g, r不可能等于b
                if bgColor.r > bgColor.b {// r = g > b
                    //bgGreen = ((bgColor.g - bgColor.b) * sat)/(bgColor.r - bgColor.b)
                    bgGreen = 0.0
                    bgRed = sat // 最大值设为 sat
                } else { // b > r = g
                    //bgRed = ((bgColor.r - bgColor.g) * sat)/(bgColor.b - bgColor.g)
                    bgRed = 0.0
                    bgBlue = sat // 最大值设为 sat
                }
            }
            return (r:bgRed, g:bgGreen, b:bgBlue)
        }
        
    }
    
    func lumFunc(bgColor:colorG) -> Double {
        return 0.3*bgColor.r + 0.59*bgColor.g + 0.11*bgColor.b
    }
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "face_01")
        return view
    }()
    lazy var filterView: UIView = {
        let view = UIView()
        return view
    }()
}
