//
//  CQCalendarEventHeader.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/10/12.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarEventHeader: UICollectionReusableView {

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
        
        let imageViewX = CGFloat(9.0)
        let imageViewY = CGFloat(0.0)
        let imageViewW:CGFloat = 15.0
        let imageViewH = self.frame.height - imageViewY
        self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
        
        let titleLabelX = self.imageView.frame.maxX
        let titleLabelY = imageViewY
        let titleLabelH = imageViewH
        let titleLabelW = self.frame.width - titleLabelX
        //let titleLabelW = self.titleLabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: titleLabelH)).width
        self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
    }
    //MARK:setupUI
    func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
    }
    //MARK:lazy
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "ic_st")
        view.contentMode = .center
        return view
    }()
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont(name: "PingFangSC-Bold", size: 17.0)
        lab.textColor = UIColor.colorHex(hex: "#3A3A3A")
        lab.text = "提醒事项"
        return lab
    }() 
}
