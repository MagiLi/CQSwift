//
//  CQCFlowLayoutStow.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/30.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCFlowLayoutStow: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
}
