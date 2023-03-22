//
//  CQGlobal.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/3/22.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation

func CQLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {

    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    // 为日期格式器设置格式字符串
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    // 使用日期格式器格式化当前日期、时间
    let datestr = dformatter.string(from: Date())
    print("\(datestr) [文件名:\(fileName)]:[行数:\(lineNum)]-打印内容:\n\(message)")
    
    #endif

}
