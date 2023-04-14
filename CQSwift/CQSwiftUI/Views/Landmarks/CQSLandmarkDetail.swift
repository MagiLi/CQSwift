//
//  CQSLandmarkDetail.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/13.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSLandmarkDetail: View {
    
    @EnvironmentObject var modelData:CQSModelData
    var landmark:CQSLandmark
    
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex { $0.id == landmark.id }!
    }
    
    var body: some View {
        ScrollView {
            CQSMapView(coordinate: landmark.locationCoordinate)
                .frame(height: 300.0)
                .ignoresSafeArea(edges: .top)
            
            CQSCircleImage(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text(landmark.name)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.red)
                HStack {
                    Text(landmark.park)
                        .font(.subheadline)
//                    Spacer()
//                    Text(landmark.state)
//                        .font(.subheadline)
                    CQSFavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                }
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CQSLandmarkDetail_Previews: PreviewProvider {
    
    static let modelData = CQSModelData()
    
    static var previews: some View {
        CQSLandmarkDetail(landmark: modelData.landmarks[0])
            .environmentObject(modelData)
    }
}
