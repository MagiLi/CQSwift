//
//  PHCDatePickerContentView.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2022/10/14.
//  Copyright © 2022 yhb. All rights reserved.
//

import UIKit

class PHCDatePickerContentView: UIView {

    var content: String? {
        didSet {
            self.titleLab.text = content
        }
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
        
        self.titleLab.frame = self.bounds
    }
    //MARK: setupUI
    func setupUI() {
        self.addSubview(self.titleLab)
    }
    
    //MARK: lazy
    lazy var titleLab: UILabel = {
        let lable = UILabel() 
        lable.textAlignment = .center
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        lable.backgroundColor = UIColor.clear
        return lable
    }()
}
