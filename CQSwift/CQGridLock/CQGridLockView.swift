//
//  CQGridLockView.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/9/28.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit


enum GridUnlockResultType:Int {
    case unknow = 0
    case failed = 1
    case success = 2
}

class CQGridLockView: UIView {

    fileprivate var resultType:GridUnlockResultType = .unknow // 解锁结果
    fileprivate var panFinished = false // 拖拽完成
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
    }
    //MARK:setupUI
    func setupUI() {
        
    }
    //MARK:lazy
    lazy var selectedItems: NSMutableArray = {
        let array = NSMutableArray()
        return array
    }()
}
