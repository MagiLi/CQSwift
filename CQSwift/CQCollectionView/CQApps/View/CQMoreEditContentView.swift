//
//  CQMoreEditContentView.swift
//  ccbpuhui
//
//  Created by llbt2019 on 2020/4/14.
//  Copyright © 2020 yhb. All rights reserved.
//

import UIKit

class CQMoreEditContentView: UIView {
    
    var maxCount = 4

    func setData(_ modelArray:[CQAppModel]) {
        let count = (modelArray.count > maxCount) ? maxCount : modelArray.count
        self.subviews.forEach { (view) in
            if view.isKind(of: UIImageView.self) {
                let imageView = view as! UIImageView
                if imageView.tag >= count {
                    imageView.isHidden = true
                } else {
                    let model = modelArray[imageView.tag]
                    imageView.image = UIImage.init(named: model.imageName ?? "")
                    imageView.isHidden = false
                }
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
        let margin = CGFloat(10.0)
        let imageViewY = CGFloat(0.0)
        let imageViewW = (self.frame.width + margin) / CGFloat(maxCount) - margin
        let imageViewH = self.frame.height
        self.subviews.forEach { (view) in
            if view.isKind(of: UIImageView.self) {
                let imageViewX = CGFloat(view.tag) * (margin + imageViewW)
                view.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewH)
            }
        }
    }
    //MARK:setupUI
    func setupUI() {
        for i in 0..<maxCount {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tag = i
            //imageView.backgroundColor = UIColor.lightGray
            self.addSubview(imageView)
        }
    }
    //MARK:lazy

}
