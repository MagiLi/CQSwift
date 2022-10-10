//
//  CQCDay.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/19.
//  Copyright © 2022 李超群. All rights reserved.
//

import Foundation
import EventKit

struct CQCDay {
    let date: Date
    let number: String
    let isToday: Bool // 是否是当天
    let isWithinDisplayedMonth: Bool // 是否在该月份内
    
    var isSelected: Bool = false // 是否是选中状态
    var event:EKEvent? = nil
    var index:Int = 0 // 集合中的索引
}
