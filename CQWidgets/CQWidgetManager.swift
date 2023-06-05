//
//  CQWidgetManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/6/5.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

class CQWidgetManager: NSObject {
    static let manager: CQWidgetManager = {
        let manager = CQWidgetManager()
        return manager
    }()
    
    //MARK: 主动刷新小组件
    // 刷线所有小组件
    func reloadAllTimeline() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    // 刷线单个小组件
    func reloadTimeline(_ kind:String) {
        WidgetCenter.shared.reloadTimelines(ofKind: kind)
    }
}
