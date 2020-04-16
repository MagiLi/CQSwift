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
            ["imageName":"ic_wydk", "title":"我要贷款", "appId":"01"],
            ["imageName":"ic_wyzy", "title":"我要支用", "appId":"02"],
            ["imageName":"ic_wyyy", "title":"我要预约", "appId":"06"],
            ["imageName":"ic_wyhk", "title":"我要还款", "appId":"03"],
            ["imageName":"ic_ysh", "title":"悦生活", "appId":"07"],
            ["imageName":"ic_zhsf", "title":"智慧税服", "appId":"13"],
            ["imageName":"ic_invest", "title":"投资理财", "appId":"09"]
        ]
        return array
    }()
    lazy var arrayData: [[String:Any]] = {
        let array = [
            ["title":"信贷融资",
             "list":[
                ["imageName":"ic_wydk", "title":"我要贷款", "appId":"01"],
                ["imageName":"ic_wyzy", "title":"我要支用", "appId":"02"],
                ["imageName":"ic_wyhk", "title":"我要还款", "appId":"03"],
                ["imageName":"ic_jdcx", "title":"进度查询", "appId":"04"]],
             "typeId":""],
            ["title":"增值服务",
             "list":[
                ["imageName":"ic_bxfw", "title":"权益领取", "appId":"05"],
                ["imageName":"ic_wyyy", "title":"我要预约", "appId":"06"],
                ["imageName":"ic_ysh", "title":"悦生活", "appId":"07"],
                ["imageName":"ic_xyk", "title":"信用卡", "appId":"08"],
                ["imageName":"ic_invest", "title":"投资理财", "appId":"09"],
                ["imageName":"ic_hqc", "title":"惠企查", "appId":"10"],
                ["imageName":"ic_xwzs", "title":"小微指数", "appId":"11"]],
             "typeId":""],
            ["title":"智慧城市",
             "list":[
                ["imageName":"ic_zhgs", "title":"智慧工商", "appId":"12"],
                ["imageName":"ic_zhsf", "title":"智慧税服", "appId":"13"]],
             "typeId":""],
            ["title":"集团和第三方",
             "list":[
                ["imageName":"ic_fykt", "title":"防疫课堂", "appId":"14"],
                ["imageName":"ic_clz", "title":"线上菜篮子", "appId":"15"],
                ["imageName":"ic_cloudClass", "title":"云课堂", "appId":"16"]],
             "typeId":""]
            
        ]
        return array
    }()
}
