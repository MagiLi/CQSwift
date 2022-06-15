//
//  CQNestedSubTableView.swift
//  CQSwift
//
//  Created by 李超群 on 2022/5/18.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQNestedSubTableView: UITableView {
    
    var canScroll = false
    
    //MARK: init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
//        self.delegate = self
//        self.dataSource = self
//        self.backgroundColor = CQRandomColor
//        self.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellID")
        
    }
    
//    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentOffset" {
//            if let scrollV = object as? UIScrollView {
////                print("observeValue: contentOffset \(scrollV.contentOffset)")
//            }
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
