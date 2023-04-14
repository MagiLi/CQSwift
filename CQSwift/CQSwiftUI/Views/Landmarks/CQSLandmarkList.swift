//
//  CQSLandmarkList.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/13.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSLandmarkList: View {
    
    @EnvironmentObject var modelData: CQSModelData
    
    // 用@State修饰，会实时监听showFavoritesOnly属性的改变，更新视图
    @State private var showFavoritesOnly = false
    
    var filteredLandmark:[CQSLandmark] {
        
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                //使用$前缀访问状态变量或其属性之一的绑定。
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredLandmark) { landmark in
                    NavigationLink {
                        CQSLandmarkDetail(landmark: landmark)
                    } label: {
                        CQSLandmarkRow(landmark: landmark)
                    }
                }
               
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct CQSLandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        
//        ForEach(["iPhone SE (3rd generation)", "iPhone 14"], id: \ .self) { deviceName in
//            CQSLandmarkList()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
        
        CQSLandmarkList()
            .environmentObject(CQSModelData())
        
            //.previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
