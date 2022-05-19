//
//  CQNestedManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/5/19.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQNestedManager: NSObject {
    
    static let shared : CQNestedManager = {
        return CQNestedManager()
    }()
    
    let tag1Count = 10
    let tag2Count = 50
    let tag3Count = 15
    let tag4Count = 30
    let subTableViewRowHeight:CGFloat = 30.0 // 子TableView的行高
    var currentTableViewIndex = 0 // 当前展示的子TableView
    
    //MARK: 计算子TableView的高度
    func calculateSubTableViewHeight(_ maxHeight:CGFloat) -> CGFloat {
        let count = self.numberOfRows(self.currentTableViewIndex)
        let height = CGFloat(count) * subTableViewRowHeight
        if height > maxHeight {
            return maxHeight
        } else {
            return height
        }
    }
    
    func numberOfRows(_ tag:Int) -> Int {
        if tag == 0 {
            return tag1Count
        } else if tag == 1 {
            return tag2Count
        } else if tag == 2 {
            return tag3Count
        } else if tag == 3 {
            return tag4Count
        }
        return 50
    }
}
