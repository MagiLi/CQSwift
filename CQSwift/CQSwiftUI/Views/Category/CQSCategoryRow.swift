//
//  CQSCategoryRow.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/17.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSCategoryRow: View {
    
    var  categoryName: String
    var items: [CQSLandmark]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15.0)
                .padding(.top, 5.0)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(alignment: .top, spacing: 5) {
                    ForEach(items) { landmark in
                        NavigationLink {
                            CQSLandmarkDetail(landmark: landmark)
                        } label: {
                            CQSCategoryItem(landmark: landmark)
                        }
                        
                    }
                }
                .frame(height: 185.0)
            }
            
        }
        
    }
}

struct CQSCategoryRow_Previews: PreviewProvider {
    static let landmarks = CQSModelData().landmarks
    static var previews: some View {
        CQSCategoryRow(
            categoryName: landmarks[0].category.rawValue,
            items: Array(landmarks.prefix(4))
        )
    }
}
