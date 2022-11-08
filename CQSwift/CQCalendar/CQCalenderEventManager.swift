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
//            print("================ /n \(event.occurrenceDate ?? Date())")
//            print("\(event.title ?? "") : startDate \(event.startDate ?? Date()) endDate \(event.endDate ?? Date())")

        })
        
        return array 
    }
    
    //MARK: 重复规则
    class fileprivate func recurrenceRule() -> EKRecurrenceRule? {
        
        let sunday = EKRecurrenceDayOfWeek(.sunday)
        let monday = EKRecurrenceDayOfWeek(.monday)
        //EKRecurrenceFrequency
        
        /*
         recurrenceWith: 重复规则
                                    EKRecurrenceFrequencyDaily每天,
                                    EKRecurrenceFrequencyWeekly每周,
                                    EKRecurrenceFrequencyMonthly每月,
                                    EKRecurrenceFrequencyYearly每年
         interval: 闹铃重复的间隔（例如：如果recurrenceWith为每天重复，interval的值为2 就表示每2天重复一次。如果recurrenceWith为每周重复，interval的值为2 就表示每2周重复一次。）
         daysOfTheWeek: EKRecurrenceDayOfWeek对象的数组。对所有重复类型有效，每日除外
         daysOfTheMonth: NSNumber的数组（[+/-]1到31）。负数表示从月底开始计数。
         daysOfTheYear: NSNumber的数组（[+/1]1到366）。负数表示从年底开始计数。
         monthsOfTheYear: 一组NSNumber（1到12）。仅对年度复发有效。
         weeksOfTheYear: NSNumber的数组（[+/1]1到53）。负数表示从年底开始计数。
         setPositions : NSNumber的数组（[+/1]1到366）。在递归计算结束时用于将列表筛选到指定的位置。
         负数表示从末尾开始，即-1表示取集合的最后一个结果。当超过daysOfTheWeek、daysOftTheMonth、monthsOfTheYear、weeksOfTheYear或daysOf theYear时有效。
         end: EKRecurrenceEnd(occurrenceCount: 3) 重复3次结束 （例如：
            1、10月1号的事项, 重复类型为日，interval为2，即每2天重复一次。重复3次结束 即10.1号一次 10.3号1次 10.5号一次。
             2、10月1号的事项, 重复类型为周，interval为2，即每2周重复一次。重复3次结束。）
               也可以以结束时间来创建该对象。
         */
        //EKRecurrenceRule(recurrenceWith: .weekly, interval: 5.0, daysOfTheWeek: [sunday, monday], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: mol, daysOfTheYear: nil, setPositions: <#T##[NSNumber]?#>, end: <#T##EKRecurrenceEnd?#>)
        return nil
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
