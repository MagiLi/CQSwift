//
//  CQSProfileSummary.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/17.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSProfileSummary: View {
    @EnvironmentObject var modelData: CQSModelData
    var profile: CQSProfile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(profile.username)
                    .bold()
                    .font(.title)
                
                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
                Text("Seasonal Photos: \(profile.seasonalPhoto.rawValue)")
                Text("Goal Date: ") + Text(profile.goalDate, style: .date)
                
                Divider()
                
                ScrollView(.horizontal) {
                    HStack {
                        
                        CQSHikeBadge(name: "First Hike")
                        CQSHikeBadge(name: "Earth Day")
                            .hueRotation(Angle(degrees: 90))
                        CQSHikeBadge(name: "Tenth Hike")
                            .grayscale(0.5)
                            .hueRotation(Angle(degrees: 45))
                    }
                    .padding(.bottom)
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Recent Hike")
                        .font(.headline)
                    CQSHikeView(hike: modelData.hikes[0])
                }
                
            }
        }
    }
}

struct CQSProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        CQSProfileSummary(profile: .default)
            .environmentObject(CQSModelData())
    }
}
