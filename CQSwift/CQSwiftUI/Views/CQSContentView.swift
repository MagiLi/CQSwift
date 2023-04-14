//
//  CQSContentView.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/7.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSContentView: View {
    // 在应用程序的生命周期内，使用@StateObject属性只初始化给定属性的模型对象一次。
     @StateObject private var modelData = CQSModelData()
    
    var body: some View {
        CQSLandmarkList()
            .environmentObject(modelData)
    }
}

struct CQSContentView_Previews: PreviewProvider {
    static var previews: some View {
        CQSContentView()
            .environmentObject(CQSModelData())
    }
}
