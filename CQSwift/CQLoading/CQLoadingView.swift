//
//  CQLoadingView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/5/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQLoadingView: UIView {
    
    func invalidate() {
        self.animateView.invalidate()
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
        let animateViewW:CGFloat = 40.0
        let animateViewH:CGFloat = 45.0
        let animateViewX:CGFloat = (self.frame.width - animateViewW) * 0.5
        let animateViewY:CGFloat = 11.0
        self.animateView.frame = CGRect(x: animateViewX, y: animateViewY, width: animateViewW, height: animateViewH)
        
        let titleLabW:CGFloat = 85.0
        let titleLabH:CGFloat = 30.0
        let titleLabX:CGFloat = (self.frame.width - titleLabW) * 0.5
        let titleLabY:CGFloat = self.animateView.frame.maxY - 5.0
        self.titleLab.frame = CGRect(x: titleLabX, y: titleLabY, width: titleLabW, height: titleLabH)
    }
    //MARK:setupUI
    func setupUI() {
        self.backgroundColor = .white
        self.addSubview(self.animateView)
        self.addSubview(self.titleLab)
    }
    //MARK:lazy
    lazy var animateView: CQLoadingAnimateView = {
        let view = CQLoadingAnimateView()
        return view
    }()
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.text = "加载中..."
        lab.textAlignment = .center
        lab.textColor =  UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        lab.font = UIFont.systemFont(ofSize: 11.0)
        return lab
    }()
    
    deinit {
        print("CQLoadingView - deinit")
    }
}

