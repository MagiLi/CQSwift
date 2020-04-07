//
//  CQModelManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/7.
//  Copyright © 2020 李超群. All rights reserved.
//

import Foundation

public protocol DataConvertible {
    func asData() throws -> Data
}

struct CQModelManager {
    
    fileprivate static let kModelCacheName = "CQModelCache" //文件夹名字
    
    // 模型存到沙盒
    public static func saveModel(_ model:DataConvertible, _ key:String) -> Bool {
        guard let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            debugPrint("获取沙盒目录失败!")
            return false
        }
        
        let userDirPath = URL(fileURLWithPath: docPath).appendingPathComponent(kModelCacheName)
        
        guard (try? FileManager.default.createDirectory(at: userDirPath, withIntermediateDirectories: true, attributes: [:])) != nil else {
            debugPrint("创建沙盒文件目录失败!")
            return false
        }
        
        let dataFullPath = "\(docPath)/\(kModelCacheName)/\(key)"
        debugPrint("存储路径/n\(dataFullPath)")
        
        guard let data = try? model.asData() else {
            return false
        }
        
        if NSKeyedArchiver.archiveRootObject(data, toFile: dataFullPath) == false {
            debugPrint("存储二进制失败!")
            return false
        }
        return true
    }
    // 查询
    static func queryModel<T: Codable>(_ type:T.Type, _ key: String) -> T? {
        
        guard let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            debugPrint("获取沙盒目录失败!")
            return nil
        }
        
        let dataFullPath = "\(docPath)/\(kModelCacheName)/\(key)"
        
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: "\(dataFullPath)") as? Data else {
            debugPrint("获取data失败!")
            return nil
        }
        
        guard let model = try? JSONDecoder().decode(type, from: data) else {
            debugPrint("转model失败!")
            return nil
        }
        
        return model
    }
    
    static func removeAll() {
        guard let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            debugPrint("获取沙盒目录失败!")
            return
        }
        
        let dirPath = "\(docPath)/\(kModelCacheName)"
        
        try? FileManager.default.removeItem(atPath: dirPath)
    }
}
