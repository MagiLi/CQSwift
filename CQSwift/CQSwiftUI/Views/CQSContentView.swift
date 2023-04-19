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
    
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CQSCategoryHome()
                .environmentObject(modelData)
                .tabItem({
                    Label("Featured", systemImage: "star")
                })
                .tag(Tab.featured)

            CQSLandmarkList()
                .environmentObject(modelData)
                .tabItem({
                    Label("List", systemImage: "list.bullet")
                })
                .tag(Tab.list)
        }
        
//        let cards = CQSModelData().features.map({ landmark in
//            CQSFeatureCard(landmark: landmark)
//        })
//        CQSPageView(pages: cards)
        
//        CQSHikeView(hike: CQSModelData().hikes[0])
        
//        CQSCategoryHome()
//            .environmentObject(modelData)
    }
}

struct CQSContentView_Previews: PreviewProvider {
    static var previews: some View {
        CQSContentView()
            .environmentObject(CQSModelData())
    }
}
