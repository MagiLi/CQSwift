//
//  CQSHexagonParameters.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/14.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation
import CoreGraphics

struct CQSHexagonParameters {
    
    struct CQSSegment {
        let line: CGPoint
        let curve: CGPoint
        let control: CGPoint
    }
    
    static let adjustment = 0.085
    
    static let segments = [
        CQSSegment(
            line: CGPoint(x: 0.60, y: 0.05),
            curve: CGPoint(x: 0.40, y: 0.05),
            control: CGPoint(x: 0.50, y: 0.00)
        ),
        CQSSegment(
            line: CGPoint(x: 0.05, y: 0.20 + adjustment),
            curve: CGPoint(x: 0.00, y: 0.30 + adjustment),
            control: CGPoint(x: 0.00, y: 0.25 + adjustment)
        ),
        CQSSegment(
            line: CGPoint(x: 0.00, y: 0.70 - adjustment),
            curve: CGPoint(x: 0.05, y: 0.80 - adjustment),
            control: CGPoint(x: 0.00, y: 0.75 - adjustment)
        ),
        CQSSegment(
            line: CGPoint(x: 0.40, y: 0.95),
            curve: CGPoint(x: 0.60, y: 0.95),
            control: CGPoint(x: 0.50, y: 1.00)
        ),
        CQSSegment(
            line: CGPoint(x: 0.95, y: 0.80 - adjustment),
            curve: CGPoint(x: 1.00, y: 0.70 - adjustment),
            control: CGPoint(x: 1.00, y: 0.75 - adjustment)
        ),
        CQSSegment(
            line: CGPoint(x: 1.00, y: 0.30 + adjustment),
            curve: CGPoint(x: 0.95, y: 0.20 + adjustment),
            control: CGPoint(x: 1.00, y: 0.25 + adjustment)
        )
    ]
}
