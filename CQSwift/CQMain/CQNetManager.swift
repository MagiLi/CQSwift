//
//  CQNetManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/6/1.
//  Copyright © 2023 李超群. All rights reserved.
//

import UIKit
import Alamofire

class CQNetManager:NSObject {
    
    static let manager: CQNetManager = {
        let manager = CQNetManager()
        return manager
    }()
    
    fileprivate let sessionManager : SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()

}
