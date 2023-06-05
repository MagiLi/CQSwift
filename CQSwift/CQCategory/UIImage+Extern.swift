//
//  UIImage+Extern.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/14.
//  Copyright © 2022 李超群. All rights reserved.
//

import Foundation
import SwiftUI

extension UIImage {
    
    //MARK: 图片文字合成
    func composeText(_ attStr:NSAttributedString) -> UIImage? {
        
        let w = self.size.width
        let h = self.size.height
        
        UIGraphicsBeginImageContext(self.size)
        let imgRect = CGRect(x: 0.0, y: 0.0, width: w, height: h)
        self.draw(in: imgRect)
        let textRect = CGRect(x: 0.0, y: 0.0, width: w, height: h)
        attStr.draw(in: textRect)
        let composedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return composedImg
    }
    
    //MARK: 用颜色绘制图片
    static func createImage(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
    static func loadImage(_ url:URL) -> Image {
        if let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
           let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
            return Image(cgImage, scale: 1.0, label: Text(""))
        } else {
            return Image("placeholder")
        }
    }
}

