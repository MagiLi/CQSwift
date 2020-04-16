//
//  PHAppModel+CoreDataClass.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/9.
//  Copyright © 2020 yhb. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CQFrequentlyAppModel)
public class CQFrequentlyAppModel: NSManagedObject {

    
    // insert
    @nonobjc class func insertModel(_ model:CQAppModel) ->CQFrequentlyAppModel? {
        if let frequentlyModel = self.queryModel(model) {// 存在更新数据
            frequentlyModel.title = model.title
            frequentlyModel.appId = model.appId
            frequentlyModel.imageName = model.imageName
            try? CQCoreDataTool.shared.managedObjectContext.save()
            return frequentlyModel
        }  else {// 不存在创建数据
            let frequentlyModel = self.createFrequentlyAppModel()
            frequentlyModel.title = model.title
            frequentlyModel.appId = model.appId
            frequentlyModel.imageName = model.imageName
            try? CQCoreDataTool.shared.managedObjectContext.save()
            return frequentlyModel
        }
    }
    @nonobjc class func insertModels(_ modelArray:[CQAppModel]) {
        
        modelArray.enumerated().forEach { (arg0) in
            let (index, model) = arg0
            let frequentlyModel = self.createFrequentlyAppModel()
            frequentlyModel.title = model.title
            frequentlyModel.appId = model.appId
            frequentlyModel.imageName = model.imageName
            frequentlyModel.index = Int16(index)
        }
        try? CQCoreDataTool.shared.managedObjectContext.save()
    }
    @nonobjc class func updateAllModels(_ modelArray:[CQAppModel]) {
        // 1.删除所有
        let frequentlyModelArray = self.queryAllModel()
        frequentlyModelArray?.enumerated().forEach({ (arg0) in
            let (_ , frequentlyModel) = arg0
            CQCoreDataTool.shared.managedObjectContext.delete(frequentlyModel)
        })
        // 2.保存所有
        modelArray.enumerated().forEach { (arg0) in
            let (index, model) = arg0
            let frequentlyModel = self.createFrequentlyAppModel()
            frequentlyModel.title = model.title
            frequentlyModel.appId = model.appId
            frequentlyModel.imageName = model.imageName
            frequentlyModel.index = Int16(index)
        }
        try? CQCoreDataTool.shared.managedObjectContext.save()
    }
   
    // delete
    @nonobjc class func deleteModel(frequentlyAppModel: CQFrequentlyAppModel) {
         CQCoreDataTool.shared.managedObjectContext.delete(frequentlyAppModel)
         do {
             try CQCoreDataTool.shared.managedObjectContext.save()
         } catch  { }
     }
    @nonobjc class func deleteModel(model: CQAppModel) {
        if let frequentlyModel = self.queryModel(model) {
            CQCoreDataTool.shared.managedObjectContext.delete(frequentlyModel)
        }
        
        do {
            try CQCoreDataTool.shared.managedObjectContext.save()
        } catch  { }
    }
    // query
    @nonobjc class func queryModel(_ model: CQAppModel) ->CQFrequentlyAppModel? {
        let predicate = self.getNSPredicate(model)
        let fetchRequest = self.fetchRequestModel()
        fetchRequest.predicate = predicate
        do  {
            let resultArray = try CQCoreDataTool.shared.managedObjectContext.fetch(fetchRequest)
            if let model = resultArray.first {
                return model
            }
        } catch { }
        return nil
    }
    @nonobjc class func queryAllModel() ->[CQFrequentlyAppModel]? {
        let sort = self.sortIndexAscending(true)
        let fetchRequest = self.fetchRequestModel()
        fetchRequest.sortDescriptors = [sort]
        
        do  {
            let resultArray = try CQCoreDataTool.shared.managedObjectContext.fetch(fetchRequest)
            return resultArray
        } catch { }
        return nil
    }
    
}
