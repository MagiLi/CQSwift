//
//  CQSFavoriteButton.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/14.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSFavoriteButton: View {
    
    // 因为使用@Binding，所以在此视图中所做的更改会传播回数据源。
    //binding是一个值，也是改变这个值的一种方式。
    //绑定控制值的存储，因此可以将数据传递给需要读取或写入数据的不同视图。
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .gray)
        }
    }
}

struct CQSFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        CQSFavoriteButton(isSet: .constant(false))
    }
}
