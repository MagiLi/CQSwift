//
//  ObservableConvertibleType.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 9/17/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

/// Type that can be converted to observable sequence (`Observable<E>`).
/// 能够转化为可视化序列的类型
public protocol ObservableConvertibleType {
    /// Type of elements in sequence.
    /// 序列中的元类型
    associatedtype E

    /// Converts `self` to `Observable` sequence.
    /// 将‘self’转换为`Observable`序列
    /// - returns: Observable sequence that represents `self`.
    /// - returns：代表self的可视化序列
    func asObservable() -> Observable<E>
}
