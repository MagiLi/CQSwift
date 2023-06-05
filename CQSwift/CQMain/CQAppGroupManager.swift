//
//  CQAppGroupManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/6/5.
//  Copyright © 2023 李超群. All rights reserved.
//
 
import SwiftUI

let groupIdentifier = "group.com.ccb.leye.test2"

struct CQAppGroupManager {
    
    static func saveImage(_ filename:String, img:UIImage) {
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
            CQLog("\(groupIdentifier) 路径没找到")
            return
        }
        var imagesURL:URL
        if #available(iOS 16.0, *) {
            imagesURL = groupURL.appending(component: "Images", directoryHint: .isDirectory)
        } else {
            imagesURL = groupURL.appendingPathComponent("Images", isDirectory: true)
        }
        //        var imgURL:URL
        //        if #available(iOS 16.0, *) {
        //            imgURL = imagesURL.appending(component: filename, directoryHint: .notDirectory)
        //        } else {
        //            imgURL = groupURL.appendingPathComponent(filename, isDirectory: false)
        //        }
        CQLog(imagesURL.absoluteString)
        do {
            try img.jpegData(compressionQuality: 1.0)!.write(to: imagesURL)
        } catch {
            CQLog(error.localizedDescription)
        }
        
        //        let saveSuccess = FileManager.default.createFile(atPath: imagesURL.path, contents: img.jpegData(compressionQuality: 1.0))
        //        CQLog("saveSuccess: \(saveSuccess)")
    }
    
    static func defaultsSave() {
        guard let defaults = UserDefaults(suiteName: groupIdentifier) else { return }
        defaults.set("widget", forKey: "key")
    }
    static func defaultsGet() -> Any? {
        guard let defaults = UserDefaults(suiteName: groupIdentifier) else { return nil }
        return defaults.object(forKey: "key") 
    }
}
