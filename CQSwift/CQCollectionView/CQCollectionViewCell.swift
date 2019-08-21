//
//  CQCollectionViewCell.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/21.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

class CQCollectionViewCell: UICollectionViewCell {

    public var content: NSString! {
        didSet {
            titleLab.text = content as String
        }
    }
    
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.colorWithCustom(r: 0.0, g: 0.0, b: 0.0)
        lab.font = UIFont.systemFont(ofSize: 20.0)
        return lab
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.red
        self.setupUI()
    }


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.addSubview(self.titleLab)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLab.frame = CGRect(x: 0.0, y: 0.0, width: self.cq_width, height: self.cq_height)
    }
}
