//
//  CQGrayView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/12/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQGrayView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: setupUI
    func setupUI() {
        self.isUserInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .gray
        self.layer.compositingFilter = "saturationBlendMode"
    }
    
    //MARK: lazy
}
