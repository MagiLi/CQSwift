//
//  CQCalendarTipsFooter.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/10/13.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarTipsFooter: UICollectionReusableView {
    
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
        
        let imageViewX = CGFloat(10.0)
        let imageViewY = CGFloat(0.0)
        let imageViewW:CGFloat = 25.0
        let imageViewH:CGFloat = 25.0
        self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
        
        let titleLabelX = self.imageView.frame.maxX
        let titleLabelY = imageViewY
        let titleLabelH = imageViewH
        let titleLabelW:CGFloat = 80.0
        self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        
        let descLabelX:CGFloat = 15.0
        let descLabelY = self.titleLabel.frame.maxY
        let descLabelH:CGFloat = self.frame.height - descLabelY - 15.0
        let descLabelW = self.frame.width - descLabelX - 15.0
        self.descLabel.frame = CGRect(x: descLabelX, y: descLabelY, width: descLabelW, height: descLabelH)
    }
    //MARK:setupUI
    func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.descLabel)
    }
    //MARK:lazy
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "calendar_tips")
        view.contentMode = .center
        return view
    }()
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16.0)
        lab.textColor = UIColor.colorHex(hex: "#666666")
        lab.text = "温馨提示"
        return lab
    }()
    lazy var descLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 16.0)
        lab.textColor = UIColor.colorHex(hex: "#666666")
        lab.numberOfLines = 0
        return lab
    }()
    
}
