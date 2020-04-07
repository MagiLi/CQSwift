//
//  CQTransitionModelManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import Foundation

struct CQTransitionModelManager {
    // 字典转模型
    public static func toModelObject<T>(_ dictionary: Any?, to type: T.Type) -> T? where T: Decodable {
        guard let dictionary = dictionary else {
            debugPrint("传入的数据解包失败!")
            return nil
        }
        
        if !JSONSerialization.isValidJSONObject(dictionary) {
            debugPrint("不是合法的json对象!")
            return nil
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            debugPrint("JSONSerialization序列化失败!")
            return nil
        }
        
        guard let model = try? JSONDecoder().decode(type, from: data) else {
            debugPrint("JSONDecoder字典转模型失败!")
            return nil
        }
        
        return model
    }
    
    // 数组转模型
    public static func toModelArray<T>(_ array: Any?, to type: T.Type) -> [T]? where T: Decodable {
        
        guard let array = array else {
            debugPrint("传入的数据解包失败!")
            return nil
        }
        
        if !JSONSerialization.isValidJSONObject(array) {
            debugPrint("不是合法的json对象!")
            return nil
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: []) else {
            debugPrint("JSONSerialization序列化失败!")
            return nil
        }
        
        guard let arrayModel = try? JSONDecoder().decode([T].self, from: data) else {
            debugPrint("JSONDecoder数组转模型失败!")
            return nil
        }
        
        return arrayModel
    }
}
