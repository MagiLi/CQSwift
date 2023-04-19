//
//  CQSHikeBadges.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/17.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSHikeBadge: View {
    
    var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            CQSBadge()
                .frame(width: 300, height: 300)
                .scaleEffect(1.0 / 3.0)
                .frame(width: 100, height: 100)
            Text(name)
                .font(.caption)
                .accessibilityLabel("Badge for \(name).")
        }
    }
}

struct CQSHikeBadge_Previews: PreviewProvider {
    static var previews: some View {
        CQSHikeBadge(name: "汾河谷地")
    }
}
