//
//  CQSCategoryItem.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/17.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSCategoryItem: View {
    
    var landmark:CQSLandmark
    
    var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155.0, height: 155.0)
                .cornerRadius(5)
            Text(landmark.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding(.leading, 15)
    }
}

struct CQSCategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CQSCategoryItem(landmark: CQSModelData().landmarks[0])
    }
}
