//
//  CQCalendarFooter.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/19.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarFooter: UICollectionReusableView {
    
    var stowBlock:((_ stow:Bool)->())?
    
    @objc func stowButtonClicked(_  sender:UIButton) {
        sender.isSelected = !sender.isSelected
        self.stowBlock?(sender.isSelected)
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
        let  stowBtnW:CGFloat = 70.0
        let  stowBtnH:CGFloat = self.frame.height
        let  stowBtnX:CGFloat = (self.frame.width - stowBtnW) * 0.5
        let  stowBtnY:CGFloat =  (self.frame.height - stowBtnH) * 0.5
        self.stowBtn.frame = CGRect(x: stowBtnX, y: stowBtnY, width: stowBtnW, height: stowBtnH)
    }
    
    //MARK: setupUI
    func setupUI() {
        self.addSubview(self.stowBtn)
    }
    
    //MARK: lazy
    lazy var stowBtn: UIButton = {

        let btn = UIButton()
        btn.setTitle("收起", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13.0)
        btn.addTarget(self, action: #selector(stowButtonClicked(_ :)), for: .touchUpInside)
        btn.setTitleColor(UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0), for: .normal)
        btn.setImage(UIImage(named: "arrow_top"), for: .normal)
        if #available(iOS 15.0, *) {
            // 初始化一个configuration，有多种方法，可根据需要选择
            var configuration = UIButton.Configuration.plain()
            // title 和 subtitle的对其关系，文本是上下排版的
            //configuration.titleAlignment = .leading
            // title he subtitle的间距
            //configuration.titlePadding = 16.scaleToScreen()
            // image 和 文本 的相对位置
            configuration.imagePlacement = .top
            // image 和 文本的间距
            configuration.imagePadding = 5
            // button的内容（title，subtitle，image）显示后与按钮的边距，默认由一段距离
            //configuration.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
            btn.configuration = configuration

            // 设置按钮的状态变化的监听，根据变化来改变按钮的显示内容
            btn.configurationUpdateHandler = {(button: UIButton) -> Void in
                //根据状态修改内容
                switch button.state {
                case .normal, .highlighted: break
//                    // image变化
//                    button.configuration?.image = UIImage.arrowPickUp
//                    // 背景的变化，默认会有些自带效果，
//                    button.configuration?.background.backgroundColor = .clear
//                    // 字体的样式与之前一样
//                    button.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
//                        NSAttributedString.Key.font : UIFont.customMediumFont(ofSize: UIFont.sizeL),
//                        NSAttributedString.Key.foregroundColor : UIColor.whiteAlpha50 ?? .red]))
//                    // 子标题，iOS15之后才有，对应的button.subtitleLabel
//                    button.configuration?.subtitle = "abc"

                case .selected, [.selected, .highlighted]: break

                case .disabled: break
                default: break // 默认值
                }
                button.updateConfiguration()
                
            }
        } else {
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 30.0)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 43.0, bottom: 0, right: 0.0)
        }
        
        return btn
    }()
}
