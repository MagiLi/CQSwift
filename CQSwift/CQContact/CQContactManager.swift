//
//  CQContactManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/16.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit
import Contacts

class CQContactManager: NSObject {
    
    //MARK: 过滤手机号特殊字符串
    class func filterPhoneSpecialString(_ phone:String) -> String {
        var numString = phone
        numString = numString.replacingOccurrences(of: "+86", with: "")
        numString = numString.replacingOccurrences(of: "-", with: "")
        numString = numString.replacingOccurrences(of: "(", with: "")
        numString = numString.replacingOccurrences(of: ")", with: "")
        numString = numString.replacingOccurrences(of: " ", with: "")
        numString = numString.replacingOccurrences(of: " ", with: "")
        return numString
    }
    
    //MARK: 通讯录请求授权
    class func requestContactAuth(authSuccess:@escaping()->(), authFailed:@escaping()->()) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: { (authed, error) in
            DispatchQueue.main.async {
                if authed { // 授权成功
                    authSuccess()
                } else { // 授权失败
                    authFailed()
                }
            }
        })
    }
    
    
    //MARK: 系统设置
    class func openSystemSettings() {
        let url = URL.init(string: UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url!, options: [:]) { (success) in }
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
}
