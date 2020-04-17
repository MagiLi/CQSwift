//
//  CQMoreDataManager.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/14.
//  Copyright © 2020 yhb. All rights reserved.
//

import UIKit

class CQMoreDataManager: NSObject {
    
    var modelArray:[CQAppModel] = {
        return Array<CQAppModel>()
    }()
    var sectionModelArray:[CQAppSectionModel] = {
        return Array<CQAppSectionModel>()
    }()
    
    static let shared : CQMoreDataManager = {
        let manager = CQMoreDataManager()
        manager.getMoreData()
        return manager
    }()
    
    func getMoreData() {
        self.sectionModelArray = CQTransitionModelManager.toModelArray(self.arrayData, to: CQAppSectionModel.self)!
        
        if let modelArray = CQFrequentlyAppModel.queryAllModel(), modelArray.count > 0 {
            modelArray.forEach { (storeModel) in
                let model = CQAppModel()
                model.title = storeModel.title
                model.imageName = storeModel.imageName
                model.appId = storeModel.appId
                model.item = Int(storeModel.item)
                model.section = Int(storeModel.section)
                self.modelArray.append(model)
            }
        } else {
            self.modelArray = CQTransitionModelManager.toModelArray(self.defaultStoreArray, to: CQAppModel.self)!
            //CQFrequentlyAppModel.insertModels(self.modelArray)
        }
    }
    // 首页默认展示
    lazy var defaultStoreArray:[[String: Any]] = {
        let array = [
            ["imageName":"ic_wydk", "title":"我要贷款", "appId":"01", "item":0, "section":0],
            ["imageName":"ic_wyzy", "title":"我要支用", "appId":"02", "item":1, "section":0],
            ["imageName":"ic_wyyy", "title":"我要预约", "appId":"06", "item":1, "section":1],
            ["imageName":"ic_wyhk", "title":"我要还款", "appId":"03", "item":2, "section":0],
            ["imageName":"ic_ysh", "title":"悦生活", "appId":"07", "item":2, "section":1],
            ["imageName":"ic_zhsf", "title":"智慧税服", "appId":"13", "item":1, "section":2],
            ["imageName":"ic_invest", "title":"投资理财", "appId":"09", "item":4, "section":1]
        ]
        return array
    }()
    lazy var arrayData: [[String:Any]] = {
        let array = [
            ["title":"信贷融资",
             "list":[
                ["imageName":"ic_wydk", "title":"我要贷款", "appId":"01", "item":0, "section":0],
                ["imageName":"ic_wyzy", "title":"我要支用", "appId":"02", "item":1, "section":0],
                ["imageName":"ic_wyhk", "title":"我要还款", "appId":"03", "item":2, "section":0],
                ["imageName":"ic_jdcx", "title":"进度查询", "appId":"04", "item":3, "section":0]],
             "typeId":""],
            ["title":"增值服务",
             "list":[
                ["imageName":"ic_bxfw", "title":"权益领取", "appId":"05", "item":0, "section":1],
                ["imageName":"ic_wyyy", "title":"我要预约", "appId":"06", "item":1, "section":1],
                ["imageName":"ic_ysh", "title":"悦生活", "appId":"07", "item":2, "section":1],
                ["imageName":"ic_xyk", "title":"信用卡", "appId":"08", "item":3, "section":1],
                ["imageName":"ic_invest", "title":"投资理财", "appId":"09", "item":4, "section":1],
                ["imageName":"ic_hqc", "title":"惠企查", "appId":"10", "item":5, "section":1],
                ["imageName":"ic_xwzs", "title":"小微指数", "appId":"11", "item":6, "section":1]],
             "typeId":""],
            ["title":"智慧城市",
             "list":[
                ["imageName":"ic_zhgs", "title":"智慧工商", "appId":"12", "item":0, "section":2],
                ["imageName":"ic_zhsf", "title":"智慧税服", "appId":"13", "item":1, "section":2]],
             "typeId":""],
            ["title":"集团和第三方",
             "list":[
                ["imageName":"ic_fykt", "title":"防疫课堂", "appId":"14", "item":0, "section":3],
                ["imageName":"ic_clz", "title":"线上菜篮子", "appId":"15", "item":1, "section":3],
                ["imageName":"ic_cloudClass", "title":"云课堂", "appId":"16", "item":2, "section":3]],
             "typeId":""]
            
        ]
        return array
    }()
}
