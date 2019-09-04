//
//  Disposable.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 2/8/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

/// Represents a disposable resource.
/// 一个任意的资源
public protocol Disposable {
    /// Dispose resource.
    /// 处理资源
    func dispose()
}
