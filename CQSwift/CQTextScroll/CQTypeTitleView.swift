//
//  CQTypeTitleView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/14.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQTypeTitleView: UIControl {
    var title: String? {
        didSet {
            self.titleLab.text = title ?? ""
            //self.setNeedsLayout()
        }
    }
    
    var selectedStatus: Bool = false {
        didSet {
            if self.selectedStatus {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.titleLab.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: { success in
                    self.titleLab.textColor = .systemBrown
                    self.titleLab.font = UIFont.boldSystemFont(ofSize: 16.0)
                    self.lineView.isHidden = false
                })
                
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.titleLab.transform = CGAffineTransform.identity
                }, completion: { success in
                    self.titleLab.textColor = .systemRed
                    self.titleLab.font = UIFont.systemFont(ofSize: 16.0)
                    self.lineView.isHidden = true
                }) 
            }
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
        self.layoutNoIcon()
    }
    
    fileprivate func  layoutNoIcon() {
        let viewWidth = self.frame.width
        let viewHeight = self.frame.height
        let titleLabX:CGFloat = -5.0
        let titleLabY:CGFloat = 0.0
        let titleLabW = viewWidth - titleLabX * 2.0
        let titleLabH = viewHeight
        self.titleLab.frame = CGRect(x: titleLabX, y: titleLabY, width: titleLabW, height: titleLabH)

        let lineViewW:CGFloat = 35.0
        let lineViewH:CGFloat = 3.0
        let lineViewX:CGFloat = (viewWidth - lineViewW) * 0.5
        let lineViewY:CGFloat = viewHeight - lineViewH
        self.lineView.frame = CGRect(x: lineViewX, y: lineViewY, width: lineViewW, height: lineViewH)
    }
    //MARK:setupUI
    func setupUI() {
        self.addSubview(self.titleLab)
        self.addSubview(self.lineView)
    }
     
    //MARK:lazy
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .systemRed
        lab.font = UIFont.systemFont(ofSize: 16.0)
        lab.textAlignment = .center
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.isHidden = true
        return view
    }()
}
