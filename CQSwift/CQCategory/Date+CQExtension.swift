//
//  Date+CQExtension.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/11/8.
//  Copyright © 2022 李超群. All rights reserved.
//

import Foundation

extension Date {
    
    public init?(fromString string: String,
                 format: String,
                 timezone: TimeZone = TimeZone.autoupdatingCurrent,
                 locale: Locale = Locale.current) {
        
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.locale = locale
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    
}
