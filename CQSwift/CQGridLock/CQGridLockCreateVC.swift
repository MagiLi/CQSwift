//
//  CQGridLockCreateVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/9/28.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit

class CQGridLockCreateVC: UIViewController {
    @objc func dismissButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(self.dismissBtn)
        self.view.addSubview(self.iconView)
        self.view.addSubview(self.tipLabel)
        self.view.addSubview(self.indicatorView)
        self.view.addSubview(self.lockView)
    }
    //MARK:
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let dismissBtnX:CGFloat = 0.0
        let dismissBtnY = self.view.safeAreaInsets.top
        let dismissBtnW:CGFloat = 60.0
        let dismissBtnH:CGFloat = 60.0
        self.dismissBtn.frame = CGRect(x: dismissBtnX, y: dismissBtnY, width: dismissBtnW, height: dismissBtnH)
        
        let iconViewY = self.dismissBtn.frame.maxY - 10.0
        let iconViewW:CGFloat = 56.0
        let iconViewX = (self.view.bounds.width - iconViewW) * 0.5
        let iconViewH:CGFloat = 56.0
        self.iconView.frame = CGRect(x: iconViewX, y: iconViewY, width: iconViewW, height: iconViewH)
        
        let indicatorViewY = self.iconView.frame.maxY
        let indicatorViewW:CGFloat = 60.0
        let indicatorViewX = (self.view.bounds.width - indicatorViewW) * 0.5
        let indicatorViewH:CGFloat = 60.0
        self.indicatorView.frame = CGRect(x: indicatorViewX, y: indicatorViewY, width: indicatorViewW, height: indicatorViewH)
        
        let tipLabelY = self.indicatorView.frame.maxY
        let tipLabelW = self.view.bounds.width
        let tipLabelX = (self.view.bounds.width - tipLabelW) * 0.5
        let tipLabelH:CGFloat = 50.0
        self.tipLabel.frame = CGRect(x: tipLabelX, y: tipLabelY, width: tipLabelW, height: tipLabelH)
        
        let lockViewX:CGFloat = 0.0
        let lockViewW = self.view.frame.width
        let lockViewH = lockViewW
        let lockViewY = self.tipLabel.frame.maxY + (self.view.frame.height - self.tipLabel.frame.maxY - lockViewH) * 0.5
        self.lockView.frame = CGRect(x: lockViewX, y: lockViewY, width: lockViewW, height: lockViewH)
    }

    //MARK: lazy
    lazy var dismissBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("∵", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 40.0)
        btn.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .cyan
        return btn
    }()
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gesture_headIcon")
        return imageView
    }()
    lazy var indicatorView: CQGridLockIndicatorView = {
        let view = CQGridLockIndicatorView()
        view.backgroundColor = .orange
        return view
    }()
    lazy var tipLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.text = "请绘制手势密码"
        lab.font = UIFont.systemFont(ofSize: 12.0)
        lab.textColor = .red
        return lab
    }()

    lazy var lockView: CQGridLockView = {
        let view = CQGridLockView()
        view.backgroundColor = .red
        return view
    }()

}
