//
//  CQSRoateBadgeSymbol.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/14.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSRoateBadgeSymbol: View {
    
    var angle: Angle
    
    var body: some View {
        CQSBadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct CQSRoateBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        CQSRoateBadgeSymbol(angle: Angle(degrees: 5))
    }
}
