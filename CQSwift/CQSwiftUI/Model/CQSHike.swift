//
//  CQSHike.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/14.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation

struct CQSHike: Codable, Hashable, Identifiable {
    var name: String
    var id: Int
    var distance: Double
    var difficulty: Int
    var observations: [CQSObservation]
    
    static var formatter = LengthFormatter()
    
    var distanceText: String {
        CQSHike.formatter.string(fromValue: distance, unit: .kilometer)
    }
    
    struct CQSObservation: Codable, Hashable {
        
        var elevation: Range<Double>
        var pace: Range<Double>
        var heartRate: Range<Double>
        
        var distanceFromStart: Double
    }
}
