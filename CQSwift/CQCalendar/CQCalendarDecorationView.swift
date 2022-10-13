//
//  CQCalendarDecorationView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/30.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarDecorationView: UICollectionReusableView { 
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientView.frame = self.bounds
    }
    //MARK: setupUI
    func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(self.gradientView)
    }
    
    //MARK: lazy
    lazy var gradientView: CQCalendarGradientView = {
        let view = CQCalendarGradientView()
        return view
    }()
}
