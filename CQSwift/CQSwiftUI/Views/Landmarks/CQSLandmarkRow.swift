//
//  CQSLandmarkRow.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/13.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSLandmarkRow: View {
    
    var landmark:CQSLandmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            
            Spacer()
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct CQSLandmarkRow_Previews: PreviewProvider {
    static var landmarks = CQSModelData().landmarks
    static var previews: some View {
        
//        ForEach([landmarks[0], landmarks[1]]) { landmark in
//            CQSLandmarkRow(landmark: landmark)
//        }

        Group {
            CQSLandmarkRow(landmark: landmarks[0])
            CQSLandmarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
        
    }
}
