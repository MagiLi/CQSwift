//
//  CQSContentView.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/7.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSContentView: View {
    var body: some View {
        VStack {
            CQSMapView()
                .frame(height: 300.0)
                .ignoresSafeArea(edges: .top)
            
            CQSCircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text(/*@START_MENU_TOKEN@*/"你好SwiftUI"/*@END_MENU_TOKEN@*/)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.red)
                HStack {
                    Text("清风拂面")
                        .font(.subheadline)
                    Spacer()
                    Text("潇潇洒洒")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("SwiftUI 动画风格好看")
                    .font(.title2)
                Text("清风拂万里 心神照苍穹")
            }
            .padding()
            
            Spacer()
        }
    }
}

struct CQSContentView_Previews: PreviewProvider {
    static var previews: some View {
        CQSContentView()
    }
}
