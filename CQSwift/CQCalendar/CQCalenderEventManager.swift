//
//  CQCalenderEventManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/29.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit
import EventKit

class CQCalenderEventManager: NSObject {
 
    class func query(startDate:Date, endDate:Date, calendars:[EKCalendar]?) -> [EKEvent]? {
        let eventStore = EKEventStore()
        var array:[EKEvent] = []
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        eventStore.enumerateEvents(matching: predicate, using:  { (event, pointer) in
            array.append(event)
            print("================ /n \(event.occurrenceDate ?? Date())")
            print("\(event.title ?? "") : startDate \(event.startDate ?? Date()) endDate \(event.endDate ?? Date())")

        })
        
        return array 
    }
    
    class func requestEventAuthorization(grantBlock:@escaping()->(), ungrantBlock:@escaping()->()) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (success, error)  in
            print(Thread.current)
            DispatchQueue.main.async {
                if !success {
                    print("没有访问日历的权限：\(error?.localizedDescription ?? "")")
                    ungrantBlock()
                    return
                }
                
                grantBlock()
            }
        })
    }
}
