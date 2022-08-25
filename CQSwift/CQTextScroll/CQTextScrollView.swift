//
//  CQTextScrollView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/25.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQTextScrollView: UIScrollView {
    
    fileprivate var displayLink: CADisplayLink?
    
    //MARK: 计时器
    @objc fileprivate func displayLinkTriggered() {
        if self.contentOffset.x > self.contentLab.frame.width {
            self.contentOffset.x = 0.0
        } else {
            self.contentOffset.x = self.contentOffset.x + 0.5
        }
    }
    
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
        
        let msg = "三大噶是共和国发生的风格大是大非哈规范士大夫撒给了法国卡收费拉萨"
        let att:[NSAttributedString.Key : Any] = [
            .font: UIFont(name: "PingFangSC-Semibold", size: 13.0)!,
            .foregroundColor: UIColor.red
        ]
        let attMsg = NSAttributedString(string: msg, attributes: att)
        let rect = attMsg.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20.0), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let labWidth = rect.size.width
        
//        let model = PHNotifyModel()
//        model.rightdesctribe = "待办"
//        model.leftdesctribe = msg
//        self.contentLab.model = model
        self.contentLab.attributedText = attMsg
        let contentLabX:CGFloat = 0.0
        let contentLabY:CGFloat = 0.0
        let contentLabW:CGFloat = labWidth
        let contentLabH:CGFloat = 30.0
        self.contentLab.frame = CGRect(x: contentLabX, y: contentLabY, width: contentLabW, height: contentLabH)
        
        self.contentSize = CGSize(width: labWidth, height: 30.0)
        
        if self.displayLink == nil {
            self.displayLink = CADisplayLink.init(target: self, selector: #selector(displayLinkTriggered))
            self.displayLink?.add(to: RunLoop.current, forMode: .common)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: setupUI
    func setupUI() {
        self.backgroundColor = .lightGray
        self.addSubview(self.contentLab)
    }
    
    //MARK: lazy
    lazy var contentLab: UILabel = {
        let lab = UILabel()
        return lab
    }()
}
