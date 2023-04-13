//
//  CQSLandmarkList.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/13.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSLandmarkList: View {
    var body: some View {
        NavigationView {
            List(landmarks) { landmark in
                NavigationLink {
                    CQSLandmarkDetail(landmark: landmark)
                } label: {
                    CQSLandmarkRow(landmark: landmark)
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
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
