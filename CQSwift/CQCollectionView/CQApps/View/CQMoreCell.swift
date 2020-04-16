//
//  CQMoreCell.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/10.
//  Copyright © 2020 yhb. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
protocol CQMoreCellDelegate {
    func reduceOrAddAppEvent(_ cell: CQMoreCell)
}

@available(iOS 11.0, *)
class CQMoreCell: UICollectionViewCell {
    
    var delegate: CQMoreCellDelegate?
    var model: CQAppModel?
    var indexPath: IndexPath!
    
    //MARK: setModel
    func setFrequentlyAppModel(_ frequentlyModel: CQAppModel?) {
        self.model = frequentlyModel
        if let frequentlyModel = frequentlyModel {
            self.imageView.image = UIImage.init(named: frequentlyModel.imageName ?? "")
            self.titleLable.text = frequentlyModel.title
            
            self.setDeleteStatus()//可删除状态
        } else {
            self.setAddPlaceholderStatus()//可添加占位状态
        }
     
    }
     
    func setAppsModel(_ model: CQAppModel) {
        self.model = model
        self.imageView.image = UIImage.init(named: model.imageName ?? "")
        self.titleLable.text = model.title
        
        if model.editing == true {// 编辑状态
            if model.status == .added {
                self.setAddedStatus()//已添加状态
            } else {
                self.setAddStatus()//可添加状态
            }
        } else {// 非编辑状态
            self.setUnediteStatus()
        }
    }
    func setUnediteStatus() {
        self.editeBtn.isHidden = true
        self.contentView.isHidden = false
        self.addPlaceholderView.isHidden = true
    }
    func setAddStatus() {
        self.editeBtn.isHidden = false
        self.contentView.isHidden = false
        self.addPlaceholderView.isHidden = true
        self.editeBtn.setImage(UIImage(named: "app_add"), for: .normal)
    }
    func setAddedStatus() {
        self.editeBtn.isHidden = false
        self.contentView.isHidden = false
        self.addPlaceholderView.isHidden = true
        self.editeBtn.setImage(UIImage(named: "app_ok"), for: .normal)
    }
    func setDeleteStatus() {
        self.editeBtn.isHidden = false
        self.contentView.isHidden = false
        self.addPlaceholderView.isHidden = true
        self.editeBtn.setImage(UIImage(named: "ic_delete"), for: .normal)
    }
    func setAddPlaceholderStatus() {
        self.editeBtn.isHidden = true
        self.contentView.isHidden = true
        self.addPlaceholderView.isHidden = false
        self.editeBtn.setImage(UIImage(named: "ic_add_placeholder"), for: .normal)
    }
    //MARK:editButtonClicked
    @objc func editButtonClicked(_ sender: UIButton) {
        self.delegate?.reduceOrAddAppEvent(self)
    }
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:setupUI
    func setupUI() {
        
        self.addSubview(self.addPlaceholderView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLable)
        self.contentView.addSubview(self.editeBtn)
    }
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleLableH = CGFloat(32.0)
        
        let imageViewY = CGFloat(11.0)
        let imageViewH = self.frame.height - titleLableH - imageViewY
        let imageViewW = imageViewH
        let imageViewX = (self.frame.width - imageViewW) * 0.5
        self.imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
        
        self.addPlaceholderView.frame = self.imageView.frame
        
        let titleLableX = CGFloat(0.0)
        let titleLableY = self.imageView.frame.maxY
        let titleLableW = self.frame.width
        self.titleLable.frame = CGRect(x: titleLableX, y: titleLableY, width: titleLableW, height: titleLableH)
        
        let editeBtnW = CGFloat(26.0)
        let editeBtnH = CGFloat(26.0)
        //let editeBtnX = imageViewW * 0.5 + 16.0
        let editeBtnX = self.imageView.frame.maxX
        let editeBtnY = CGFloat(0.0)
        self.editeBtn.frame = CGRect(x: editeBtnX, y: editeBtnY, width: editeBtnW, height: editeBtnH)
    }
    //MARK: lazy
    lazy var addPlaceholderView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.image = UIImage(named: "ic_add_placeholder")
        return view
    }()
    
    
    lazy var editeBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .center
        //imgView.backgroundColor = UIColor.randomColor()
        imgView.backgroundColor = UIColor.cyan
        return imgView
    }()
    lazy var titleLable: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor(rgba: "#3A3A3A")
        lab.font = UIFont.systemFont(ofSize: 12.0)
        lab.textAlignment = .center
        return lab
    }()
}
