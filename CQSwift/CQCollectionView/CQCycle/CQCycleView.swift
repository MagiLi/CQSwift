//
//  CQCycleView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/3/23.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCycleView: UIScrollView {
    
//    override func touchesShouldCancel(in view: UIView) -> Bool {
//        if self.panGestureRecognizer.numberOfTouches == 0 {
//            return true
//        } else {
//            return false
//        }
//    }
    
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK:setupUI
    func setupUI() {
        
    }
    //MARK:lazy

}
