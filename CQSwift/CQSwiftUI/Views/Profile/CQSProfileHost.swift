//
//  CQSProfileHost.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/17.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSProfileHost: View {
    
    // @Environment为属性提供存储
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData:CQSModelData
    @State private var draftProfile = CQSProfile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                
                if editMode?.wrappedValue == .active {
                    
                    Button("Cancel") {
                        draftProfile = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                EditButton()
            }
            
            if editMode?.wrappedValue == .inactive {
                CQSProfileSummary(profile: modelData.profile)
            } else {
                Text("Profile Editor")
                CQSProfileEditor(profile: $draftProfile)
                    .onAppear{
                        draftProfile = modelData.profile
                    }
                    .onDisappear {
                        modelData.profile = draftProfile
                    }
            }
            
        }
        .padding()
    }
}

struct CQSProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        CQSProfileHost()
            .environmentObject(CQSModelData())
    }
}
