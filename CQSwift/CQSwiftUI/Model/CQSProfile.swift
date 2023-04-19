//
//  CQSProfile.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/17.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation

struct CQSProfile {
    var username: String
    var prefersNotifications = true
    var seasonalPhoto = CQSSeason.spring
    var goalDate = Date()
    
    static let `default` = CQSProfile(username: "g_kumar")
    
    enum CQSSeason: String, CaseIterable, Identifiable {
        case spring = "💐"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "🐛"
        
        var id: String { rawValue }
    }
}
