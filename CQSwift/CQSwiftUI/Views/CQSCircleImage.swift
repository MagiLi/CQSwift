//
//  CQSCircleImage.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/7.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI

struct CQSCircleImage: View {
    
    var  image: Image
    
    var body: some View {
        if #available(iOS 15.0, *) {
            image.clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
        } else {
            image.clipShape(Circle())
        }
        
    }
}

struct CQSCircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CQSCircleImage(image: Image("charleyrivers"))
    }
}
