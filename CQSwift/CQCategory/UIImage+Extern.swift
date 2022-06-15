//
//  UIImage+Extern.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/14.
//  Copyright © 2022 李超群. All rights reserved.
//

import Foundation

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
    
}

