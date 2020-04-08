//
//  CQAppModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

class CQAppSectionModel: Codable, DataConvertible {
    
    static let kAppSectionModel = "appSectionModel" //存的文件名
    
    var typeId:String?
    var list:[CQAppModel]?
    var title:String?
    
    func asData() throws -> Data {
        
        guard let data = try? JSONEncoder().encode(self) else {
            throw CQError.invalidData(data: self)
        }
        
        return data
    }
    
}

class CQAppModel: Codable {
    
    var title:String?
    var appId:String?
    var selected:Bool?
    
}
