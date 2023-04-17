//
//  CQSModelData.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/13.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation

final class CQSModelData: ObservableObject {
    // 可观察对象需要发布对其数据的任何更改，以便其订阅者能够获取更改。
    // 所以需要@Published修饰
    @Published var  landmarks:[CQSLandmark] = load("landmarkData.json")
    
    var  hikes:[CQSHike] = load("hikeData.json")
    
    var features: [CQSLandmark] {
        landmarks.filter{ $0.isFeatured }
    }
    
    var category: [String: [CQSLandmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
}



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
