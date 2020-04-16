//
//  CQMoreEditHeader.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/10.
//  Copyright © 2020 yhb. All rights reserved.
//

import UIKit

protocol CQMoreEditHeaderDelegate {
    func editButtonClickedEvent(_ sender:UIButton)
}

@available(iOS 11.0, *)
class CQMoreEditHeader: UICollectionReusableView {
    
    var delegate: CQMoreEditHeaderDelegate?
    var maxCount = 4
    
    func setEditHeaderData(_ modelArray:[CQAppModel]) {
        if modelArray.count > self.maxCount {
            self.omitView.isHidden = false
        } else {
            self.omitView.isHidden = true
        }
        self.contentView.setData(modelArray)
    }
    // MARK: editButtonClicked
    @objc func editButtonClicked(_ sender:UIButton) {
        self.delegate?.editButtonClickedEvent(sender)
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
        let imageViewY = CGFloat(6.0)
        let imageViewW = CGFloat(17.0)
        let imageViewH = self.frame.height - imageViewY
        self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
        
        let titleLabelX = self.imageView.frame.maxX
        let titleLabelY = imageViewY
        let titleLabelW = CGFloat(78.0)
        let titleLabelH = imageViewH
        self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        
        let editeBtnW = CGFloat(66.0)
        let editeBtnH = CGFloat(27.0)
        let editeBtnX = self.frame.width - editeBtnW - 10.0
        let editeBtnY = (self.frame.height - editeBtnH) * 0.5
        self.editeBtn.frame = CGRect(x: editeBtnX, y: editeBtnY, width: editeBtnW, height: editeBtnH)
        
        let omitViewW = CGFloat(34.0)
        let omitViewH = self.frame.height
        let omitViewX = editeBtnX - omitViewW - 10.0
        let omitViewY = CGFloat(0.0)
        self.omitView.frame = CGRect(x: omitViewX, y: omitViewY, width: omitViewW, height: omitViewH)
        
        let contentViewX = self.titleLabel.frame.maxX
        let contentViewW = omitViewX - contentViewX
        let contentViewH = self.frame.height
        let contentViewY = CGFloat(0.0)
        self.contentView.frame = CGRect(x: contentViewX, y: contentViewY, width: contentViewW, height: contentViewH)
    }
    //MARK:setupUI
    func setupUI() {
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentView)
        self.addSubview(self.omitView)
        self.addSubview(self.editeBtn)
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
        lab.text = "常用功能"
        return lab
    }()
    
    lazy var contentView: CQMoreEditContentView = {
        let view = CQMoreEditContentView()
        view.maxCount = maxCount
        return view
    }()
    
    lazy var omitView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = UIImage(named: "omit")
        return view
    }()
    
    lazy var editeBtn: UIButton = {
        let color = UIColor(r: 74.0, g: 122.0, b: 224.0, a: 1.0)
        let btn = UIButton()
        btn.setTitle("编辑", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12.0 )
        btn.setTitleColor(color, for: .normal)
        btn.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 2.5
        btn.layer.borderColor = color.cgColor
        btn.layer.borderWidth = 0.5
        return btn
    }()
}
