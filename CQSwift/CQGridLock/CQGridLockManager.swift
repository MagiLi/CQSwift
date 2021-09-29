//
//  CQGridLockManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/9/29.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit
let gesturePasswordStrKey = "gesturePasswordStrKey"
class CQGridLockManager: NSObject {
    class func setGesturesPassword(_ pwdStr:String) {
        UserDefaults.standard.setValue(pwdStr, forKey: gesturePasswordStrKey)
        UserDefaults.standard.synchronize()
    }
    class func getGesturesPassword() -> String? {
        return UserDefaults.standard.string(forKey: gesturePasswordStrKey) 
    }
    class func deleteGesturesPassword() {
        UserDefaults.standard.removeObject(forKey: gesturePasswordStrKey)
        UserDefaults.standard.synchronize()
    }
}
