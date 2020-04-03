//
//  CQAppCell.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

class CQAppCell: UICollectionViewCell {
    
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
        let editeBtnW = CGFloat(30.0)
        let editeBtnH = editeBtnW
        let editeBtnX = self.frame.width - editeBtnW
        let editeBtnY = CGFloat(0.0)
        self.editeBtn.frame = CGRect(x: editeBtnX, y: editeBtnY, width: editeBtnW, height: editeBtnH)
        
        let indexPathLabW = self.frame.width
        let indexPathLabH = CGFloat(20.0)
        let indexPathLabX = CGFloat(0.0)
        let indexPathLabY = (self.frame.height - indexPathLabH) * 0.5
        self.indexPathLab.frame = CGRect(x: indexPathLabX, y: indexPathLabY, width: indexPathLabW, height: indexPathLabH)
        
        let titleLabW = self.frame.width
        let titleLabH = CGFloat(20.0)
        let titleLabX = CGFloat(0.0)
        let titleLabY = self.frame.height - titleLabH
        self.titleLab.frame = CGRect(x: titleLabX, y: titleLabY, width: titleLabW, height: titleLabH)
    }
    //MARK:setupUI
    func setupUI() {
        self.backgroundColor = .cyan
        self.addSubview(self.editeBtn)
        self.addSubview(self.indexPathLab)
        self.addSubview(self.titleLab)
    }
    //MARK:lazy
    lazy var editeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "app_add"), for: .normal)
        return btn
    }()
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 15.0)
        return lab
    }()
    lazy var indexPathLab: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = .red
        lab.font = UIFont.boldSystemFont(ofSize: 15.0)
        return lab
    }()
}
