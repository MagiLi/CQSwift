//
//  CQCrossFlowHeader.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCrossFlowHeader: UICollectionReusableView {
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//
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
        let titleLbX = 21.0
        let titleLbY:CGFloat = 0.0
        let titleLbW = self.frame.width - titleLbX * 2.0
        let titleLbH = self.frame.height
        self.titleLb.frame = CGRect(x: titleLbX, y: titleLbY, width: titleLbW, height: titleLbH)
//        self.titleLb.frame = self.bounds
    }
    //MARK:setupUI
    func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(self.titleLb)
    }
    //MARK:lazy
    lazy var titleLb:UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "PingFang-SC-Medium", size: 13.0)
        lb.textColor = UIColor(named: "#888888")
        lb.backgroundColor = .clear
        return lb
    }()

}
