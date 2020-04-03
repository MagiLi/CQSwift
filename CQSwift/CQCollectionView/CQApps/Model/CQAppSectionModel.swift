//
//  CQAppModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/3.
//  Copyright © 2020 李超群. All rights reserved.
//

import UIKit

class CQAppSectionModel: Codable {

    var typeId:String?
    var list:[CQAppModel]?
    var title:String?
}

class CQAppModel: Codable {
    var title:String?
    var appId:String?
}
