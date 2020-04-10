//
//  CQCoreDataTool.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/9.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit
import CoreData

class CQCoreDataTool: NSObject {
    var storeCoordinator:NSPersistentStoreCoordinator?
    var managedObjectContext: NSManagedObjectContext!
    
    static let shared: CQCoreDataTool = {
        let tool = CQCoreDataTool.init()
        return tool
    }()
    
    func setupCoreDataWithModelName(_ modelName:String, _ dbName:String) {
        //初始化model（数据模型）
        guard let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "momd") else { return }
        guard let model = NSManagedObjectModel.init(contentsOf: modelUrl) else { return }
        
        //存储路径
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
        let dbPath = filePath + "/" + dbName
        let dbURL = URL.init(fileURLWithPath: dbPath)
        let options = [NSMigratePersistentStoresAutomaticallyOption:NSNumber.init(value: true),NSInferMappingModelAutomaticallyOption:NSNumber.init(value: true)]
        
        //持久化存储器
        self.storeCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        do {
            try self.storeCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: options)
        } catch { }
        //被管理对象的上下文
        self.managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator
    }
}
