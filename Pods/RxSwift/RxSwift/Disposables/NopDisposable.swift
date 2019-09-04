//
//  NopDisposable.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 2/15/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

/// Represents a disposable that does nothing on disposal.
/// 不做任何处理 disposable类
/// Nop = No Operation
fileprivate struct NopDisposable : Disposable {
 
    fileprivate static let noOp: Disposable = NopDisposable()
    
    fileprivate init() {
        
    }
    
    /// Does nothing.
    public func dispose() {
    }
}

extension Disposables {
    /**
     Creates a disposable(任意的) that does nothing on disposal（处置）.
     */
    static public func create() -> Disposable {
        return NopDisposable.noOp
    }
}
