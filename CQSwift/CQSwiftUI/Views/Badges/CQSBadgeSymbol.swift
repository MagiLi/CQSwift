//
//  CQSBadgeSymbol.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/14.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSBadgeSymbol: View {
    
    static let symbolColor = Color(red: 79.0 / 255.0, green: 79.0 / 255.0, blue: 191.0 / 255.0)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let middle = width * 0.5
                let spacing = width * 0.030
                let topWidth = width * 0.226
                let topHeight = height * 0.488
                
                path.addLines([
                    CGPoint(x: middle, y: spacing),
                    CGPoint(x: middle - topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: topHeight * 0.5 + spacing),
                    CGPoint(x: middle + topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: spacing),
                ])
                
                // 移动到下方图形的顶点位置
                path.move(to: CGPoint(x: middle, y: topHeight * 0.5 + spacing * 3.0))
                
                path.addLines([
                        CGPoint(x: middle - topWidth, y: topHeight + spacing),
                        CGPoint(x: spacing, y: height - spacing),
                        CGPoint(x: width - spacing, y: height - spacing),
                        CGPoint(x: middle + topWidth, y: topHeight + spacing),
                        CGPoint(x: middle, y: topHeight * 0.5 + spacing * 3.0)
                ])
            }
            .fill(CQSBadgeSymbol.symbolColor)
        }
    }
}

struct CQSBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        CQSBadgeSymbol()
    }
}
