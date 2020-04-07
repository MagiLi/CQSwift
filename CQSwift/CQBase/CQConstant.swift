//
//  CQConstant.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/21.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

// MARK:- 全局参数
let CQScreenBounds = UIScreen.main.bounds
let CQScreenW = UIScreen.main.bounds.size.width
let CQScreenH = UIScreen.main.bounds.size.height

/// 状态栏高度20
let CQStatusHeight: CGFloat = 20
/// 导航栏高度64
let CQNavHeight: CGFloat = 64
/// tabBar的高度 50
let CQTabBarHeight: CGFloat = 50
/// 全局的间距 10
let CQGloabalMargin: CGFloat = 10
/** 导航栏颜色 */
let navBarTintColor  = UIColor.colorWithCustom(r: 83, g: 179, b: 163)

/** 全局字体 */
let CQ_FONT = "Bauhaus ITC"



/// 主窗口代理
let KAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

// iOS在当前屏幕获取第一响应
let CQKeyWindow = UIApplication.shared.keyWindow
let CQFirstResponder = CQKeyWindow?.perform(Selector(("firstResponder")))


// MARK:- 通知
/// 通知中心
let CQNotificationCenter = NotificationCenter.default


