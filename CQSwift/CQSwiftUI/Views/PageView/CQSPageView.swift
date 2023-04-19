//
//  CQSPageView.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/19.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSPageView<CQSPage: View>: View {
    
    var pages: [CQSPage]
    @State private var currentPage:Int = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            CQSPageViewController(pages: pages, currentPage: $currentPage)
            CQSPageControl(numberOfPage: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
        
    }
}

struct CQSPageView_Previews: PreviewProvider {
    static var previews: some View {
        
        let cards = CQSModelData().features.map({ landmark in
            CQSFeatureCard(landmark: landmark)
        })
        
        CQSPageView(
            pages: cards
        )
        .aspectRatio(3 / 2, contentMode: .fit)
    }
}
