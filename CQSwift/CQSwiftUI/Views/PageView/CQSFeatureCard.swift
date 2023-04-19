//
//  CQSFeatureCard.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/19.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSFeatureCard: View {
    
    var landmark: CQSLandmark
    
    var body: some View {
        
        if #available(iOS 15.0, *) {
            landmark.featureImage?
                .resizable()
                .aspectRatio(3 / 2, contentMode: .fit)
                .overlay(content: {
                    CQSTextOverlay(landmark: landmark)
                })
        } else {
            let overlay = CQSTextOverlay(landmark: landmark)
            landmark.featureImage?
                .resizable()
                .aspectRatio(3 / 2, contentMode: .fit)
                .overlay(overlay)
        }
        
    }
}

struct CQSTextOverlay: View {
    
    var landmark: CQSLandmark
    
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.black.opacity(0.6), .black.opacity(0.0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(landmark.name)
                    .font(.title)
                    .bold()
                Text(landmark.park)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
    
}

struct CQSFeatureCard_Previews: PreviewProvider {
    static var previews: some View {
        CQSFeatureCard(landmark: CQSModelData().features[0])
    }
}
