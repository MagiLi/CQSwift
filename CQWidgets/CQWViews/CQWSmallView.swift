//
//  CQWSmallView.swift
//  CQWidgetsExtension
//
//  Created by llbt2019 on 2023/4/7.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQWSmallView: View {
    var body: some View {
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
        }
        .padding()
        
    }
}

struct CQWSmallView_Previews: PreviewProvider {
    static var previews: some View {
        CQWSmallView()
            
    }
}
