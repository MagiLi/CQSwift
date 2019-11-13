//
//  Producer.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 2/20/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

class Producer<Element> : Observable<Element> {
    override init() {
        super.init()
    }

    override func subscribe<O : ObserverType>(_ observer: O) -> Disposable where O.E == Element {
        if !CurrentThreadScheduler.isScheduleRequired {
            // The returned disposable needs to release all references once it was disposed.
            let disposer = SinkDisposer()
            let sinkAndSubscription = self.run(observer, cancel: disposer)
            disposer.setSinkAndSubscription(sink: sinkAndSubscription.sink, subscription: sinkAndSubscription.subscription)

            return disposer
        }
        else {
            return CurrentThreadScheduler.instance.schedule(()) { _ in
                let disposer = SinkDisposer()
                let sinkAndSubscription = self.run(observer, cancel: disposer)
                disposer.setSinkAndSubscription(sink: sinkAndSubscription.sink, subscription: sinkAndSubscription.subscription)

                return disposer
            }
        }
    }

    func run<O : ObserverType>(_ observer: O, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where O.E == Element {
        rxAbstractMethod()
    }
}

fileprivate final class SinkDisposer: Cancelable {
    fileprivate enum DisposeState: Int32 {
        case disposed = 1
        case sinkAndSubscriptionSet = 2
    }

    private let _state = AtomicInt(0)
    private var _sink: Disposable?
    private var _subscription: Disposable?

    var isDisposed: Bool {
        return isFlagSet(self._state, DisposeState.disposed.rawValue)
    }

    func setSinkAndSubscription(sink: Disposable, subscription: Disposable) {
        self._sink = sink
        self._subscription = subscription
        //self._state oldValue = 0
        //self._state newValue = 2
        // 或|
        // 0000 0000:self._state
        // 0000 0010
        // |||| ||||
        // vvvv vvvv
        // 0000 0010
        // previousState第一次来时为0，第二次来为2
        let previousState = fetchOr(self._state, DisposeState.sinkAndSubscriptionSet.rawValue)
        // 与&
        // 0000 0000    0000 0010:previousState
        // 0000 0010    0000 0010
        // |||| ||||
        // vvvv vvvv
        // 0000 0000    0000 0010
        // 第一次来时为0也就 ==0， 第二次来时为2也就 != 0
        // 满足该条件时说明Sink 和 subscription都存在了
        if (previousState & DisposeState.sinkAndSubscriptionSet.rawValue) != 0 {
            rxFatalError("Sink and subscription were already set")
        }
        // 与&
        // 0000 0000    0000 0010:previousState
        // 0000 0001    0000 0001
        // |||| ||||
        // vvvv vvvv
        // 0000 0000    0000 0000
        // 第一次为0，第二次也0
        if (previousState & DisposeState.disposed.rawValue) != 0 {
            sink.dispose()
            subscription.dispose()
            self._sink = nil
            self._subscription = nil
        }
    }

    func dispose() {
        // 或|
        // 0000 0010:self._state(2)    0000 0011
        // 0000 0001                   0000 0001
        // |||| ||||
        // vvvv vvvv
        // 0000 0011:self._state(3)    0000 0011
        
        // previousState第一次来时为2，
        // previousState第二次来时为3
        let previousState = fetchOr(self._state, DisposeState.disposed.rawValue)
        // 与&
        // 0000 0010    0000 0011:previousState
        // 0000 0001    0000 0001
        // |||| ||||
        // vvvv vvvv
        // 0000 0000    0000 0001
        // 第一次来时为0也就 == 0，第二次来时为1也就 != 0直接return
        if (previousState & DisposeState.disposed.rawValue) != 0 {
            return
        }
        // 与&
        // 0000 0011:previousState
        // 0000 0010
        // |||| ||||
        // vvvv vvvv
        // 0000 0010
        // 第一次来时为2也就 != 0
        if (previousState & DisposeState.sinkAndSubscriptionSet.rawValue) != 0 {
            guard let sink = self._sink else {
                rxFatalError("Sink not set")
            }
            guard let subscription = self._subscription else {
                rxFatalError("Subscription not set")
            }

            sink.dispose()
            subscription.dispose()

            self._sink = nil
            self._subscription = nil
        }
    }
}
