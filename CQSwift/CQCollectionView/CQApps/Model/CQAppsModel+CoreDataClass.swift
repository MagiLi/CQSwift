//
//  CQAppModel+CoreDataClass.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/9.
//  Copyright © 2020 李超群. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CQAppModel)
public class CQAppsModel: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CQAppsModel> {
        return NSFetchRequest<CQAppsModel>(entityName: "CQAppsModel")
    }
    
}
