//
//  FileManagerExtension.swift
//  CQSwiftUI
//
//  Created by llbt2019 on 2023/5/16.
//

import Foundation

extension FileManager {
    
    var documentDirectory: URL? {
        return self.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    //MARK: 创建文件夹📁
    func createFileInDocument(_ fileName: String) -> Bool{
        guard let documentDirectory = documentDirectory else { return false}
        
        let url:URL
        if #available(iOS 16.0, *) {
            url = documentDirectory.appending(component: fileName, directoryHint: .isDirectory)
        } else {
            url = documentDirectory.appendingPathComponent(fileName)
        }
        
        if fileExists(atPath: url.path) { return true }

        do {
            //withIntermediateDirectories: false 在进行此调用时该目录必须不存在。
            // true 创建任何必要的中间目录
            try createDirectory(at: url, withIntermediateDirectories: true)
            return true
        } catch  {
            return false
        }
    }
    
    //MARK: 复制数据
    func copyItemToDocumentDirectory(from sourceURL: URL, to destinationFileName:String) -> URL? {
        guard let documentDirectory = documentDirectory else { return nil }
        
        if !createFileInDocument(destinationFileName) {  return nil }
        
        let destinationFileURL = documentDirectory.appendingPathComponent(destinationFileName)
        let fileName = sourceURL.lastPathComponent
        let destinationURL = destinationFileURL.appendingPathComponent(fileName)
        if self.fileExists(atPath: destinationURL.path) {
            return destinationURL
        } else {
            do {
                try self.copyItem(at: sourceURL, to: destinationURL)
                return destinationURL
            } catch let error {
                print("Unable to copy file: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    //MARK: 获取指定目录下的数据
    func getContentsOfDirectory(from destinationFileName:String) -> [URL] {
        guard let documentDirectory = documentDirectory else { return []}
        
        let url:URL
        if #available(iOS 16.0, *) {
            url = documentDirectory.appending(component: destinationFileName, directoryHint: .isDirectory)
        } else {
            url = documentDirectory.appendingPathComponent(destinationFileName)
        }
        // url必须是一个目录
        var isDirectory: ObjCBool = false
        guard fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else { return [] }
        do {
            return try self.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch {
            print("Unable to get directory contents: \(error.localizedDescription)")
        }
        return []
    }
    //MARK: 删除
    func removeItemFromDocumentDirectory(url: URL) {
        if !self.fileExists(atPath: url.path) { return }
        do {
            try self.removeItem(at: url)
        } catch let error {
            print("Unable to remove file: \(error.localizedDescription)")
        }
    }
}
