//
//  CQNetManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/6/1.
//  Copyright © 2023 李超群. All rights reserved.
//

import UIKit
import Alamofire
import YYWebImage
import SwiftUI

class CQNetManager:NSObject {
    
    static let manager: CQNetManager = {
        let manager = CQNetManager()
        return manager
    }()
    
    // 会话管理器
    fileprivate let sessionManager : SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()

    func downLoadFile(success:@escaping(_ destinationURL: URL)->(), failure:@escaping(_ stausCode:Int)->()) {
        let imgUrl = "https://lmg.jj20.com/up/allimg/tx18/0217202027012.jpg"
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        self.sessionManager.download(imgUrl, to: destination).response { response in
            let code = response.response?.statusCode ?? -1
            CQLog("stausCode: \(code)")
            if let url = response.destinationURL {
                success(url)
            } else {
                failure(code)
            }
        }
    }
    
    func downLoadImage(success:@escaping(_ image: Image)->(), failure:@escaping(_ message:String)->()) {
        let imgUrl = "https://lmg.jj20.com/up/allimg/tx18/0217202027012.jpg"
        YYWebImageManager.shared().requestImage(with: URL(string: imgUrl)!) { receivedSize, expectedSize in
            CQLog("receivedSize:\(receivedSize) _ expectedSize:\(expectedSize)")
        } transform: { img, url in
            return img
        } completion: { image, url, fromType, stage, error in
            DispatchQueue.main.async {
                if let img = image, error == nil {
                    CQAppGroupManager.saveImage("widgetBackground", img: img)
                    success(Image(uiImage: img))
                } else {
                    let message = error?.localizedDescription ?? "获取图片失败"
                    failure(message)
                }
            }
        }
    }
   
    
}
