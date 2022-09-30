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
    let isSelected: Bool
    let isWithinDisplayedMonth: Bool
    
    var event:EKEvent? = nil
}
