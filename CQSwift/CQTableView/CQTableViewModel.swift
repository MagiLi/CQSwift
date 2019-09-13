//
//  CQTableViewModel.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/24.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct CQDataModel {
    var title : NSString?
    var subTitle : NSString?
}

struct CQTableViewCellModel {
    var array = Array<CQDataModel>()
    init() {
        array.append(CQDataModel(title: "0001", subTitle: "observable"))
        array.append(CQDataModel(title: "0002", subTitle: "小王"))
        array.append(CQDataModel(title: "0003", subTitle: "小刘"))
        array.append(CQDataModel(title: "0004", subTitle: "小黄"))
        array.append(CQDataModel(title: "0005", subTitle: "小张"))
    }
}
