//
//  CQCalendarDateHeader.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/10/13.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCalendarDateHeader: UICollectionReusableView {
    
    var date: String? {
        didSet {
            self.dateView.date = date
        }
    }
    
    //MARK: clicked
    @objc func dateViewClicked() {
        
    }
    
    @objc func addButtonClicked(_ sender:UIButton) {
        
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
        
        let dateViewW:CGFloat = 150.0
        let dateViewX:CGFloat = self.frame.midX - dateViewW + 60.0
        let dateViewY:CGFloat = 0.0
        let dateViewH = self.frame.height
        self.dateView.frame = CGRect(x: dateViewX, y: dateViewY, width: dateViewW, height: dateViewH)
        
        let addBtnW:CGFloat = 48.0
        let addBtnH:CGFloat = self.frame.height
        let addBtnX:CGFloat = self.frame.width - addBtnW
        let addBtnY:CGFloat = 0.0
        self.addBtn.frame = CGRect(x: addBtnX, y: addBtnY, width: addBtnW, height: addBtnH)
    }
    
    //MARK: setupUI
    func setupUI() {
        self.addSubview(self.dateView)
        self.addSubview(self.addBtn)
    }
    
    //MARK: lazy
    lazy var dateView: CQCDateView = {
        let label = CQCDateView()
        return label
    }()
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(addButtonClicked(_ :)), for: .touchUpInside)
        btn.setImage(UIImage(named: "calendar_custom_add"), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    //
}
