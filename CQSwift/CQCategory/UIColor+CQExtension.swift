//
//  CQ.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/21.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        let r = r/255.0
        let g = g/255.0
        let b = b/255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    static func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return colorWithCustom(r: r, g: g, b: b)
    }
    
    static func  colorWithCustom(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let r = r/255.0
        let g = g/255.0
        let b = b/255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
}

// MARK: - 16进制转UIColor
extension UIColor {
    /**
     16进制转UIColor
     
     - parameter hex: 16进制颜色字符串
     
     - returns: 转换后的颜色
     */
    static func colorHex(hex: String) -> UIColor {
        return proceesHex(hex: hex,alpha: 1.0)
    }
    
    /**
     16进制转UIColor，
     
     - parameter hex:   16进制颜色字符串
     - parameter alpha: 透明度
     
     - returns: 转换后的颜色
     */
    static func colorHexWithAlpha(hex: String, alpha: CGFloat) -> UIColor {
        return proceesHex(hex: hex, alpha: alpha)
    }
    
    /** 主要逻辑 */
    fileprivate static func proceesHex(hex: String, alpha: CGFloat) -> UIColor{
        /** 如果传入的字符串为空 */
        if hex.isEmpty {
            return UIColor.clear
        }
        
        /** 传进来的值。 去掉了可能包含的空格、特殊字符， 并且全部转换为大写 */
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        var hHex = (hex.trimmingCharacters(in: whitespace)).uppercased()
        
        /** 如果处理过后的字符串少于6位 */
        if hHex.count < 6 {
            return UIColor.clear
        }
        
        /** 开头是用0x开始的  或者  开头是以＃＃开始的 */
        if hHex.hasPrefix("0X") || hHex.hasPrefix("##") {
            hHex =  String(hHex.dropFirst(2))
        }
        
        /** 开头是以＃开头的 */
        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }
        
        /** 截取出来的有效长度是6位， 所以不是6位的直接返回 */
        if hHex.count != 6 {
            return UIColor.clear
        }
        
        /** R G B */
        var range = NSMakeRange(0, 2)
        
        /** R */
        let rHex = (hHex as NSString).substring(with: range)
        
        /** G */
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)
        
        /** B */
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)
        
        /** 类型转换 */
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    
    //    convenience init(hex string: String) {
    //        var hex = string.hasPrefix("#") ? String(string.characters.dropFirst()) : string
    //
    //        guard hex.characters.count == 3 || hex.characters.count == 6
    //            else {
    //                self.init(white: 1.0, alpha: 0.0)
    //                return
    //        }
    //
    //        if hex.characters.count == 3 {
    //            for (index, char) in hex.characters.enumerated() {
    //                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
    //            }
    //        }
    //
    //        self.init(
    //            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
    //            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
    //            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
    //    }
}
