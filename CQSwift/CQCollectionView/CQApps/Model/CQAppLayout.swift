//
//  CQAppLayout.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

class CQAppLayout: UICollectionViewFlowLayout {
    
    
    //MARK:init
    override init() {
        super.init()
        self.scrollDirection = .vertical
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:prepare
    override func prepare() {
        super.prepare()
        
    }
    
}
