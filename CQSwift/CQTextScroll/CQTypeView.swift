//
//  CQTypeView.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/14.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

protocol CQTypeViewDelegate:NSObjectProtocol {
    func titleViewClickedEvent(_ sender:CQTypeTitleView)
}

class CQTypeView: UIScrollView {
    weak var delegateClick:CQTypeViewDelegate?
    var currentSelView:CQTypeTitleView?
    var itemArray = [CQTypeTitleView]()
    let titleViewH:CGFloat = 50.0
    var titleArray:[[String:Any]]!
    
    @objc func titleViewClicked(_ sender:CQTypeTitleView) {
        if self.currentSelView == sender { return }
        self.scrollToSelIndex(sender.tag)
        self.delegateClick?.titleViewClickedEvent(sender)
    }
    // MARK: scrollToSelIndex
    func scrollToSelIndex(_ index:Int) {
        if self.itemArray.count <= index { return } // 防止越界
        if self.currentSelView?.tag == index { return }
        // 取消选中
        self.currentSelView?.selectedStatus = false
        // 设置选中
        self.currentSelView = self.itemArray[index]
        guard let selView = self.currentSelView else { return }
        selView.selectedStatus = true
    }
    
    //MARK:init
    convenience init(titleArray:[[String:Any]]) {
        self.init()
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .white
        self.titleArray = titleArray
        self.setupUI()
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.showsVerticalScrollIndicator = false
//        self.showsHorizontalScrollIndicator = false
//
//        self.setupUI()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //MARK:layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    fileprivate func calculateTitleWidth(_ title:String?) -> CGFloat {
        return CQScreenW / 4.0
//        guard let content = title else  { return 0.0 }
//        let attTitle = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 16.0)])
//        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.titleViewH)
//        let bound = attTitle.boundingRect(with: size, options:  [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
//        return bound.size.width + 20.0
    }
    
    //MARK: setupUI
    func setupUI() {
        var maxW:CGFloat = 0.0
        self.titleArray.enumerated().forEach {  [weak self] (i, dict) in
            guard let self = self else { return }
            let title = dict["title"] as? String ?? ""
            let titleViewW = self.calculateTitleWidth(title)
            let titleViewX = maxW
            let frame = CGRect(x: titleViewX, y: 0.0, width: titleViewW, height: self.titleViewH)
            maxW = maxW + titleViewW
            
            let titleView = CQTypeTitleView(frame: frame)
            //titleView.title = typeModel.title
            titleView.title = title
            titleView.tag = i
            titleView.addTarget(self, action: #selector(self.titleViewClicked(_ :)), for: .touchUpInside)
            if i == 0 {
                titleView.selectedStatus = true
                self.currentSelView = titleView
            }
            self.addSubview(titleView)
            self.itemArray.append(titleView)
        }
        //self.contentSize = CGSize(width: maxW, height: self.titleViewH)
    }
    
}
