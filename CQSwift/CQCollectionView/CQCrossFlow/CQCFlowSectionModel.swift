//
//  CQCFlowSectionModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/9/2.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCFlowSectionModel: NSObject, Codable {
    var data:[CQCFlowModel]?
    var title:String?
}

class CQCFlowModel:NSObject, Codable {

    var content:String?
    var time:String? 
}
