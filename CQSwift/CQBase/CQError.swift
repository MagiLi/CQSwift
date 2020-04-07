
//
//  CQError.swift
//  CQSwift
//
//  Created by llbt2019 on 2020/4/7.
//  Copyright © 2020 李超群. All rights reserved.
//

import Foundation

public enum CQError: Error {
    case invalidData(data:DataConvertible)
    case invalidModel(model:DataConvertible)
}

