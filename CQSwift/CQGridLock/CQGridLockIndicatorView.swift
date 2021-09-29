//
//  CQGridLockIndicatorView.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/9/28.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit

class CQGridLockIndicatorView: UIView {
    //MARK: setGesturePassword
    func setGesturePassword(_ pwdStr:String) {
        self.subviews.forEach { (view) in
            if let imgView = view as? UIImageView {
                imgView.image = UIImage(named: "灰色椭圆")
            }
        }
        if pwdStr.count == 0 { return }
        
        var index = pwdStr.startIndex
        while index != pwdStr.endIndex {
            let startIndex = index
            let endIndex = pwdStr.index(index, offsetBy: 1, limitedBy: pwdStr.endIndex) ?? pwdStr.endIndex
            let subString = pwdStr[startIndex..<endIndex]
            let num = Int(subString) ?? 0
            
            let imgView = self.subviews[num] as? UIImageView
            imgView?.image = UIImage(named: "橙色椭圆")
            index = endIndex
        }
        
//        pwdStr.endIndex
    }
    //MARK: init
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
        let count = self.subviews.count
        let columns:Int = 3
        let itemW:Int = 9
        let itemH = itemW
        let margin = (Int(self.bounds.width) - columns * itemW) / (columns + 1)
        for i in 0..<count {
            let currentRow = i / columns
            let currentCol = i % columns
            let itemX = margin + (itemW + margin) * currentCol
            let itemY = margin + (itemW + margin) * currentRow
            let imgView = self.subviews[i]
            imgView.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
        }
    }
    //MARK:setupUI
    func setupUI() {
        for i in 0...8 {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "灰色椭圆")
            imgView.tag = i
            self.addSubview(imgView)
        }
    }
    //MARK:lazy

}
