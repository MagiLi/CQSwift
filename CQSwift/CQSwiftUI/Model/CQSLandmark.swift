//
//  CQSLandmark.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/7.
//  Copyright © 2023 李超群. All rights reserved.
//

import Foundation
import SwiftUI

struct CQSLandmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state:String
    var description:String
    
    private var imageName:String
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates:Coordinates
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    struct Coordinates:Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
