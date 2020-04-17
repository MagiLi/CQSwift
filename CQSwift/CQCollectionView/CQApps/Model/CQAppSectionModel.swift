//
//  CQAppModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

enum appModelStatus: Int, Codable {
    
    case add = 0// 可添加状态
    case added = 1// 已添加状态
  
//    case delete = 2// 可删除状态
//    case addPlaceholder = 3// 可添加占位状态
}

class CQAppSectionModel:NSObject, Codable, DataConvertible {
    
    static let kAppSectionModel = "appSectionModel" //存的文件名
    
    var typeId:String?
    var list:[CQAppModel]?
    var title:String?
    var desTitleHidden:Bool?
    
    func asData() throws -> Data {
        
        guard let data = try? JSONEncoder().encode(self) else {
            throw CQError.invalidData(data: self)
        }
        
        return data
    }
    
}

class CQAppModel:NSObject, Codable {

    var title:String?
    var appId:String?
    var imageName:String?
    var status:appModelStatus?
    var editing:Bool?
    var item:Int!
    var section:Int!
}
