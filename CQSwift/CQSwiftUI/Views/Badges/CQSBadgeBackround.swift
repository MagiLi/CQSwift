//
//  CQSBadgeBackround.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/14.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSBadgeBackround: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                var width:CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width
                
                let xScale = 0.8
                let xOffset = width * (1 - xScale) * 0.5
                width = width * xScale
                
                
                
                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + CQSHexagonParameters.adjustment)
                    )
                )
                
                CQSHexagonParameters.segments.forEach { segment in
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )
                    
                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control:  CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
                
        
            }
            .fill(
                .linearGradient(
                    Gradient(colors: [CQSBadgeBackround.gradientStart, CQSBadgeBackround.gradientEnd]),
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 0.6)
                )
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    static let gradientStart = Color(red: 239.0 / 255.0, green: 120.0 / 255.0, blue: 221.0 / 255.0)
    static let gradientEnd = Color(red: 239.0 / 255.0, green: 172.0 / 255.0, blue: 120.0 / 255.0)
}

struct CQSBadgeBackround_Previews: PreviewProvider {
    static var previews: some View {
        CQSBadgeBackround()
    }
}
