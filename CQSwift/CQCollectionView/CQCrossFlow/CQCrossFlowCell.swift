//
//  CQCrossFlowCell.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCrossFlowCell: UICollectionViewCell {
    var selectedStatus: Bool? {
        didSet {
            if selectedStatus ?? false {
                self.titleLb.backgroundColor = UIColor(named: "218EE2")
                self.titleLb.textColor = .white
            } else {
                self.titleLb.backgroundColor = UIColor(named: "F5F6F7")
                self.titleLb.textColor = UIColor.black
            }
        }
    }
    
    var model: CQCFlowModel? {
        didSet {
            self.titleLb.text = model?.content
        }
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
        let titleLbX:CGFloat = 0.0
        let titleLbW = self.frame.width - titleLbX * 2.0
        self.titleLb.frame = CGRect(x: titleLbX, y: 0.0, width: titleLbW, height: self.frame.height)
//        self.titleLb.frame = self.bounds
    }
    //MARK:setupUI
    func setupUI() {
        //self.contentView.backgroundColor = UIColor(hexString: "F5F6F7")
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(self.titleLb)
    }
    //MARK:lazy
    lazy var titleLb:UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "PingFang-SC-Medium", size: 13.0)
        lb.backgroundColor = UIColor.lightGray
        lb.textColor = UIColor.black
        lb.text = "共款金融产品"
        lb.textAlignment = .center
        return lb
    }()
}
