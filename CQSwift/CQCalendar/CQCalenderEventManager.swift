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
        var array = Array<EKEvent>()
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)

        eventStore.enumerateEvents(matching: predicate, using:  { (event, pointer) in
            do {
                print( "104104" + event.title)
            } catch let error {
                print(error)
            }
            
        })
        
        return array
        
    }
    
    class func authLogic() {
//        EKEventStore()
    }
}
