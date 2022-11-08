//
//  PHCDatePickerHeaderView.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2022/10/14.
//  Copyright © 2022 yhb. All rights reserved.
//

import UIKit

class PHCDatePickerHeaderView: UIView {
    var sureBlock:(()->())?
    var cancelBlock:(()->())?
    
    //MARK: click
    @objc fileprivate func sureButtonClick() {
        self.sureBlock?()
    }
    
    @objc fileprivate func cancelButtonClicked() {
        self.cancelBlock?()
    }
     
    
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
        
        let cancelButtonX:CGFloat = 0.0
        let cancelButtonY:CGFloat = 0.0
        let cancelButtonW:CGFloat = 100.0
        let cancelButtonH:CGFloat = self.frame.height
        self.cancelButton.frame = CGRect(x: cancelButtonX, y: cancelButtonY, width: cancelButtonW, height: cancelButtonH)
        let sureButtonW = cancelButtonW
        let sureButtonX = self.frame.width - sureButtonW
        let sureButtonY = cancelButtonY
        let sureButtonH = cancelButtonH
        self.sureButton.frame = CGRect(x: sureButtonX, y: sureButtonY, width: sureButtonW, height: sureButtonH)
        
      
        let titleLabY:CGFloat = 0.0
        let titleLabH:CGFloat = self.frame.height
        let titleLabW:CGFloat = 100.0
        let titleLabX:CGFloat = (self.frame.width - titleLabW) * 0.5
        self.titleLab.frame = CGRect(x: titleLabX, y: titleLabY, width: titleLabW, height: titleLabH)
    }
    
    //MARK: setupUI
    func setupUI() {
        self.backgroundColor = UIColor(hexString: "eeeeee")
        self.addSubview(self.sureButton)
        self.addSubview(self.cancelButton)
        self.addSubview(self.titleLab)
    }
    
    //MARK: lazy
    lazy var sureButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        btn.addTarget(self, action: #selector(sureButtonClick), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 15.0)
        return btn
    }()
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        btn.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        btn.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 15.0)
        return btn
    }()
    lazy var titleLab: UILabel = {
        let lable = UILabel()
        lable.text = "请选择"
        lable.font = UIFont(name: "PingFang-SC-Medium", size: 15.0)
        lable.textColor = UIColor(hexString: "#333333")
        lable.textAlignment = .center
        lable.backgroundColor = .clear
        return lable
    }()
}
