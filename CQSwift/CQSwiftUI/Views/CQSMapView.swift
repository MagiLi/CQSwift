//
//  CQSMapView.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/7.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI
import MapKit

struct CQSMapView: View {
    
    var  coordinate:CLLocationCoordinate2D
    
    @State private var region = MKCoordinateRegion()

    
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(coordinate)
            }
    }
    
    private func setRegion(_ coordinate:CLLocationCoordinate2D) {
        region = MKCoordinateRegion(center: coordinate, span:  MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
}

struct CQSMapView_Previews: PreviewProvider {
    static var previews: some View {
        CQSMapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
