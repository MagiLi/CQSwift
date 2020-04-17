//
//  PHAppModel+CoreDataProperties.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/9.
//  Copyright © 2020 yhb. All rights reserved.
//
//

import Foundation
import CoreData


extension CQFrequentlyAppModel {
    
    @NSManaged public var title: String?
    @NSManaged public var appId: String?
    @NSManaged public var selected: Bool
    @NSManaged public var index: Int16
    @NSManaged public var imageName:String?
    @NSManaged public var item: Int16
    @NSManaged public var section: Int16
    
    @nonobjc public class func fetchRequestModel() -> NSFetchRequest<CQFrequentlyAppModel> {
        return NSFetchRequest<CQFrequentlyAppModel>(entityName: "CQFrequentlyAppModel")
    }
    
    @nonobjc class func createFrequentlyAppModel() -> CQFrequentlyAppModel {
        return NSEntityDescription.insertNewObject(forEntityName: "CQFrequentlyAppModel", into: CQCoreDataTool.shared.managedObjectContext) as! CQFrequentlyAppModel
    }
    
    @nonobjc class func getNSPredicate(_ model: CQAppModel) -> NSPredicate {
        return NSPredicate.init(format: "appId = %@", model.appId ?? "")
    }
    @nonobjc class func sortIndexAscending(_ ascending: Bool) -> NSSortDescriptor {
        return NSSortDescriptor(key: "index", ascending: ascending)
    }
}
