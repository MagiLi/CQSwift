//
//  CQAppFooterView.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

class CQAppFooterView: UICollectionReusableView {
    func setFooterTitleLab(_ section:NSInteger) {
        self.titleLab.text = "第 \(section) 组"
    }
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
        let titleLabW = self.frame.width
        let titleLabH = self.frame.height
        let titleLabX = CGFloat(0.0)
        let titleLabY = CGFloat(0.0)
        self.titleLab.frame = CGRect(x: titleLabX, y: titleLabY, width: titleLabW, height: titleLabH)
    }
    //MARK:setupUI
    func setupUI() {
        self.addSubview(self.titleLab)
    }
    //MARK:lazy
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = .black
        lab.font = UIFont.boldSystemFont(ofSize: 17.0)
        return lab
    }()
}
