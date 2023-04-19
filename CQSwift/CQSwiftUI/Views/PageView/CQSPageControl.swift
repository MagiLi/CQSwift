//
//  CQSPageControl.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/4/19.
//  Copyright © 2023 李超群. All rights reserved.
//

import SwiftUI
import UIKit

struct CQSPageControl: UIViewRepresentable {
    
    var numberOfPage:Int
    @Binding var currentPage: Int
    
    func makeCoordinator() -> CQSCoordinator {
        CQSCoordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPage
        control.addTarget(context.coordinator, action: #selector(CQSCoordinator.updateCurrentPage(sender: )), for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
  
    class CQSCoordinator: NSObject {
        var control: CQSPageControl
        init(_ pageControl: CQSPageControl) {
            self.control = pageControl
        }
        
        @objc func updateCurrentPage(sender:UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
