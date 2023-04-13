//
//  CQSModelData.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/13.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation

var  landmarks:[CQSLandmark] = load("landmarkData.json")

func load<T: Decodable>(_ filename: String) -> T {
    
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("未能在Bundle中发现文件 \(filename)")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("未能在Bundle中发现文件 \(filename) 错误:\n \(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("解析文件 \(filename) 错误\(T.self):\n \(error)")
    }
   
}
