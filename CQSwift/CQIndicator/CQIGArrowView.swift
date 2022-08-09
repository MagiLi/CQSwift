//
//  CQIGArrowView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQIGArrowView: UIView {
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
        let lightSpotViewW:CGFloat = 50.0
        
        let indicatorViewX:CGFloat = 0.0
        let indicatorViewW:CGFloat = self.bounds.width - indicatorViewX - lightSpotViewW * 0.5
        let indicatorViewH:CGFloat = 10.0
        let indicatorViewY:CGFloat = (self.bounds.height - indicatorViewH) * 0.5
        self.indicatorView.frame =  CGRect(x: indicatorViewX, y: indicatorViewY, width: indicatorViewW, height: indicatorViewH)
        
        let lightSpotViewX:CGFloat = self.indicatorView.frame.maxX - lightSpotViewW * 0.5
        let lightSpotViewH:CGFloat = 50.0
        let lightSpotViewY:CGFloat = (self.bounds.height - lightSpotViewH) * 0.5 + 2.0
        self.lightSpotView.frame = CGRect(x: lightSpotViewX, y: lightSpotViewY, width: lightSpotViewW, height: lightSpotViewH)
    }
    
    //MARK:setupUI
    func setupUI() {
        self.addSubview(self.lightSpotView)
        self.addSubview(self.indicatorView)
    }
    
    //MARK:lazy
    lazy var lightSpotView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "indicator_lightSpot")
        return view
    }()
    
    lazy var indicatorView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "indicator_h")
        return view
    }()
    
}
