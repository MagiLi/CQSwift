//
//  CQCalendarEventCell.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/10/12.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarEventCell: UICollectionViewCell {
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientView.frame = self.bounds
        
        let dateLabelX = CGFloat(0.0)
        let dateLabelY = CGFloat(0.0)
        let dateLabelW:CGFloat = 60.0
        let dateLabelH = 18.0
        self.dateLabel.frame = CGRect(x: dateLabelX, y: dateLabelY, width: dateLabelW, height: dateLabelH)
        
        let titleLabelX:CGFloat = 15.0
        let titleLabelY = self.dateLabel.frame.maxY + 11.0
        let titleLabelH:CGFloat = 21.0
        let titleLabelW = self.frame.width - titleLabelX
        self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        
        let loanLabelX = titleLabelX
        let loanLabelY = self.titleLabel.frame.maxY + 5.0
        let loanLabelW:CGFloat = 65.0
        let loanLabelH:CGFloat  = 18.5
        self.loanLabel.frame = CGRect(x: loanLabelX, y: loanLabelY, width: loanLabelW, height: loanLabelH)
        
        let loanContentLabelX = self.loanLabel.frame.maxX
        let loanContentLabelY = loanLabelY
        let loanContentLabelW:CGFloat = self.frame.width - loanContentLabelX - 50.0
        let loanContentLabelH:CGFloat  = loanLabelH
        self.loanContentLabel.frame = CGRect(x: loanContentLabelX, y: loanContentLabelY, width: loanContentLabelW, height: loanContentLabelH)
        
        let cycleLabelX = loanLabelX
        let cycleLabelY = self.loanLabel.frame.maxY + 5.0
        let cycleLabelW:CGFloat = loanLabelW
        let cycleLabelH:CGFloat  = loanLabelH
        self.cycleLabel.frame = CGRect(x: cycleLabelX, y: cycleLabelY, width: cycleLabelW, height: cycleLabelH)
        
        let cycleContentLabelX = self.cycleLabel.frame.maxX
        let cycleContentLabelY = cycleLabelY
        let cycleContentLabelW:CGFloat = loanContentLabelW
        let cycleContentLabelH:CGFloat  = cycleLabelH
        self.cycleContentLabel.frame = CGRect(x: cycleContentLabelX, y: cycleContentLabelY, width: cycleContentLabelW, height: cycleContentLabelH)
    }
    
    //MARK: setupUI
    func setupUI() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.gradientView)
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.loanLabel)
        self.contentView.addSubview(self.loanContentLabel)
        self.contentView.addSubview(self.cycleLabel)
        self.contentView.addSubview(self.cycleContentLabel)
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5.0
    }
    
    //MARK: lazy
    lazy var gradientView: CQCalendarGradientView = {
        let view = CQCalendarGradientView()
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.textColor = .white
        label.backgroundColor = UIColor.colorHex(hex: "#4A7AE0")
        label.text = "8月03日"
        return label
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor.colorHex(hex: "#333333")
        label.text = "归还利息提醒"
        return label
    }()
    lazy var loanLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = UIColor.colorHex(hex: "#999999")
        label.text = "贷款账号:"
        return label
    }()
    
    lazy var loanContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = UIColor.colorHex(hex: "#333333")
        label.text = "84***93"
        return label
    }()
    lazy var cycleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = UIColor.colorHex(hex: "#999999")
        label.text = "提醒周期:"
        return label
    }()
    lazy var cycleContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = UIColor.colorHex(hex: "#333333")
        label.text = "每月"
        return label
    }()
}
