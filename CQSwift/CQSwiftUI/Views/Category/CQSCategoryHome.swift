//
//  CQSCategoryHome.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/17.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSCategoryHome: View {
    
    @EnvironmentObject var modelData: CQSModelData
    
    var body: some View {
        NavigationView {
            List {
                
                modelData.features[0].image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(modelData.category.keys.sorted(), id: \.self) { key in
                    CQSCategoryRow(
                        categoryName: key,
                        items: modelData.category[key]!
                    )
                }
            }
            .navigationTitle("Feature")
        }
        
    }
}

struct CQSCategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CQSCategoryHome()
            .environmentObject(CQSModelData())
    }
}
