//
//  CQJSClient.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/10/13.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol CQJSClientProtocol:NSObjectProtocol, JSExport {
    func callIOS(_ methodName:String, _ data:Any) -> [String:Any]
}

@objc class CQJSClient: NSObject, CQJSClientProtocol {

    var jsContext:JSContext?
    func callIOS(_ methodName: String, _ data: Any) -> [String:Any] {
        debugPrint("methodName:\(methodName)")
        debugPrint("data:\(data)")

        
        switch methodName {
        case "presidentDataGet":
            let loginInfo:[String:Any] = [
                "result":[
                    "currentPosition":[
                        "positionId":"",
                        "positionName":"",
                        "orgName":""],
                    "":""],
                "success":"1"]
            return loginInfo
        case "getWebviewID":
            let loginInfo:[String:Any] = [
                "result":[
                    "webviewID":"000001",
                    "":""],
                "success":"1"]
            return loginInfo
        case "showLoading":
            return ["":""]
        case "getDeviceIp":
            return ["":""]
        case "getAppBundleId":
            return ["":""]
        case "isShowLittleSmartBtn":
            return ["":""]
        default:
            return ["":""]
        }
    }
 
    /*
     "methodName:presidentDataGet"
     "data:{\n    key = \"_sys_pjf_loginfo_\";\n    type = 0;\n}"
     "methodName:getWebviewID"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"sys_wv_open_time\";\n    type = 0;\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"_sys_pjf_loginfo_\";\n    type = 0;\n}"
     "methodName:getWebviewID"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"sys_wv_open_time\";\n    type = 0;\n}"
     "methodName:showLoading"
     "data:{\n    style = 1;\n    text = \"<null>\";\n    timeout = 45;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:getDeviceIp"
     "data:{\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"X-Encrypted-By\";\n    type = 0;\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"_shell_language_\";\n    type = 1;\n}"
     "methodName:getAppBundleId"
     "data:{\n}"
     "methodName:isShowLittleSmartBtn"
     "data:{\n    imageUrl = \"<null>\";\n    show = 1;\n    url = \"/static/test/indexNlp.html#/userChat?category=huiHelp\";\n}"
     "webViewDidFinishLoad"
     "methodName:presidentDataGet"
     "data:{\n    key = \"_sys_pjf_loginfo_\";\n    type = 0;\n}"
     "methodName:presidentDataGet"
     "data:{\n    key = \"_sys_pjf_loginfo_\";\n    type = 0;\n}"
     */
}
