//
//  CQMoreHeader.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/9.
//  Copyright © 2020 yhb. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class CQMoreHeader: UICollectionReusableView {
    
    var sectionModel: CQAppSectionModel = CQAppSectionModel() {
        didSet {
            self.titleLabel.text = sectionModel.title
            self.desLabel.isHidden = sectionModel.desTitleHidden ?? true
            self.setNeedsLayout()
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
        
        let imageViewX = CGFloat(0.0)
        let imageViewY = CGFloat(21.0)
        let imageViewW = CGFloat(17.0)
        let imageViewH = self.frame.height - imageViewY
        self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
        
        let titleLabelX = self.imageView.frame.maxX
        let titleLabelY = imageViewY
        let titleLabelH = imageViewH
        let titleLabelW = self.titleLabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: titleLabelH)).width
        self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        
        let desLabelX = self.titleLabel.frame.maxX
        let desLabelW = self.frame.width - desLabelX - 15.0
        let desLabelH = CGFloat(16.0)
        let desLabelY = self.titleLabel.frame.midY - desLabelH*0.5
        self.desLabel.frame = CGRect(x: desLabelX, y: desLabelY, width: desLabelW, height: desLabelH)
    }
    //MARK:setupUI
    func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.desLabel)
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
        lab.font = .systemFont(ofSize: 17.0)
        lab.textColor = UIColor(rgba: "#3A3A3A")
        lab.textAlignment = .left
        return lab
    }()
    lazy var desLabel: UILabel = {
        let lab = UILabel()
        lab.text = "(可按住拖拽调整顺序）"
        lab.font = .systemFont(ofSize: 12.0)
        lab.textColor = .lightGray
        lab.textAlignment = .left
        return lab
    }()
}
