//
//  CQAppModel+CoreDataProperties.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/9.
//  Copyright © 2020 李超群. All rights reserved.
//
//

import Foundation
import CoreData


extension CQAppsModel {

    @NSManaged public var appId: String?
    @NSManaged public var typeId: String?
    @NSManaged public var title: String?
    @NSManaged public var selected: Bool
}
