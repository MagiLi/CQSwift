//
//  CQRXDriverVC.swift
//  CQSwift
//
//  Created by 李超群 on 2019/9/28.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class CQRXDriverVC: UIViewController {
    let lgError = NSError.init(domain: "com.lgError.cn", code: 10090, userInfo: nil)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        testDriver()
        
//        testCombinationOperation()
//        testTransformingOperation()
//        testFilteringConditionalOperators()
//        testMathematicalAggregateOperators()
//        testErrorHandlingOperators()
//        testConnectableOperators()
        
    }
    
    //MARK:testDriver
    func testDriver() -> Void {
        // 1.序列初始化observableField：SharedSequence（Driver）<DriverSharingStrategy, Any>
        // 
        let observableField = self.textField.rx.text.orEmpty
            .asDriver()// Driver序列
            .flatMap {
                // 这时return了一个Driver序列：
                // 该序列内部生成并持有了一个新的source（Observable）
                return self.getSimulationData(inputText: $0)
                .asDriver(onErrorJustReturn: "===== error =====")
            }
        
        // 2.序列绑定，订阅
        observableField.map {
            "\($0)"
//            "length: \(($0 as! String).count)"
        }
        .drive(self.textLabel.rx.text)
        .disposed(by: disposeBag)
    }

    func getSimulationData(inputText: String) -> Observable<Any>{
        print("发起线程 \(Thread.current)")
        let observable = Observable<Any>.create { (anyObservable) -> Disposable in
            if inputText == "123" {
                anyObservable.onError(NSError.init(domain: "com.driver.cn", code: 10086, userInfo: nil))
            } else {
                DispatchQueue.global().async {
                    print("回调线程 \(Thread.current)")
                    // 3.发送信号
                    anyObservable.onNext("已经输入:\(inputText)")
                    anyObservable.onCompleted()
                }
            }
            return Disposables.create()
        }
        return observable
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let textlabelFrame = CGRect(x: 20.0, y: 120.0, width: 280.0, height: 50.0)
        self.textLabel.frame = textlabelFrame
        self.textField.frame = CGRect(x: 20.0, y: textlabelFrame.maxY + 15.0, width: 200.0, height: textlabelFrame.height)
    }
    //MARK: setupUI
    func setupUI() -> Void {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.textLabel)
        self.view.addSubview(self.textField)
    }
    //MARK: lazy
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "textLab"
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.orange
        return label
    }()
    lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入..."
        field.borderStyle = .roundedRect
        return field
    }()
    
    //MARK:高阶函数
    
    //MARK: 组合操作符
    func testCombinationOperation() {
        /*
        //startWith:
        Observable.of("1", "2","3")
        .startWith("a")
        .startWith("b")
        .startWith("C", "D")
        .subscribe(onNext: {
            print($0)//打印顺序C、D、b、a、1、2、3
        })
        .disposed(by: disposeBag)
        
        //merge : 将源可观察序列中的元素组合成一个新的可观察序列，并 像每个源可观察序列发出元素一样 发出每个元素
        let subjectFirst = PublishSubject<String>()
        let subjectSecond = PublishSubject<String>()
        Observable.of(subjectFirst, subjectSecond)
        .merge()
        .subscribe(onNext: {
            print($0)//打印顺序chao
        })
        .disposed(by: disposeBag)
        // 任何一个响应都会勾起新序列响应
        subjectFirst.onNext("c")
        subjectFirst.onNext("h")
        subjectSecond.onNext("a")
        subjectSecond.onNext("0")
        */
        //zip: 将多达8个源可观测序列组合成一个新的可观测序列，并将从组合的可观测序列中发射出对应索引处每个源可观测序列的元素
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        Observable.zip(stringSubject, intSubject) { (item1, item2) in
            "\(item1) + \(item2)"// 组合两个元素
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        // 说白了: 只有两个序列同时有值的时候才会响应,否则存值，不会被覆盖
        stringSubject.onNext("好好散")// 存值
        stringSubject.onNext("步步高")// 存值
        intSubject.onNext(0)// 勾出“好好散”
        intSubject.onNext(1)// 勾出“步步高”
    //combineLatest:将8源可观测序列组合成一个新的观测序列,并将开始发出联合观测序列的每个源的最新元素可观测序列一旦所有排放源序列至少有一个元素,并且当源可观测序列发出的任何一个新元素
        let stringLat = PublishSubject<String>()
        let intLat = PublishSubject<Int>()
        Observable.combineLatest(stringLat, intLat) { (item1, item2) in
            "\(item1) - \(item2)"
        }.subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        // 会被覆盖，两种类型必须都存在
        // 应用非常频繁: 比如账户和密码同时满足->才能登陆. 不关系账户密码怎么变化的只要查看最后有值就可以 loginEnable
        stringLat.onNext("我来了")
        stringLat.onNext("你走吧")
        intLat.onNext(0)// 你走吧 - 0("我来了"被覆盖)
        intLat.onNext(1)// 你走吧 - 1("0"被覆盖)
        stringLat.onNext("都闪开")//都闪开 - 1（"你走吧"被覆盖）
        
        //switchLatest : 将可观察序列发出的元素转换为可观察序列，并从最近的内部可观察序列发出元素
        let switchLatest1 = BehaviorSubject(value: "1")
        let switchLatest2 = BehaviorSubject(value: "2")
        let switchL = BehaviorSubject(value: switchLatest1)// 选择了 switchLatest1 就不会监听 switchLatest1
        switchL.asObserver()
        .switchLatest()
        .subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        // 规律：在切换到switchLatest1和switchLatest2之前设置对应的值都会被覆盖，切换之后设置值不会被覆盖
        switchLatest1.onNext("哈哈")
        switchLatest1.onNext("别笑了")// 依然会打印“哈哈”
        switchLatest2.onNext("20")// "2"会被覆盖为“20”
        switchL.onNext(switchLatest2)
        switchLatest1.onNext("继续笑吧")//不会打印
        switchLatest1.onNext("偏不笑")
        switchLatest2.onNext("22")// “20”不会被覆盖
        switchL.onNext(switchLatest1)
    }
    
    //MARK:映射操作
    func testTransformingOperation() {
        /*
        //map: 转换闭包应用于可观察序列发出的元素，并返回转换后的元素的新可观察序列。
        Observable.of(0,1,2)
            .map {
                return $0 + 2// 每个值+2
        }.subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        // *** flatMap and flatMapLatest
        // 将可观测序列发射的元素转换为可观测序列，并将两个可观测序列的发射合并为一个可观测序列。
        //这也很有用，例如，当你有一个可观察的序列，它本身发出可观察的序列，你想能够对任何一个可观察序列的新发射做出反应(序列中序列:比如网络序列中还有模型序列)
        // flatMap和flatMapLatest的区别是，flatMapLatest只会从最近的内部可观测序列发射元素
        // flatMapLatest实际上是map和switchLatest操作符的组合。
        let wang = CQPlayer(score: 100)
        let li = CQPlayer(score: 120)
        let player = BehaviorSubject(value: wang)
        player.asObserver().flatMap { (p) in
            p.score.asObservable()
        }.subscribe(onNext: { (s) in
            print(s)
        }).disposed(by: disposeBag)
        
        wang.score.onNext(60)
        player.onNext(li)
        wang.score.onNext(80)//  flatMap会打印，如果切换到 flatMapLatest 就不会打印
        wang.score.onNext(90)//  flatMap会打印，如果切换到 flatMapLatest 就不会打印
        li.score.onNext(115)
        */
        //scan: 从初始就带有一个默认值开始，然后对可观察序列发出的每个元素应用累加器闭包，并以单个元素可观察序列的形式返回每个中间结果
        Observable<Int>.of(10, 20, 30)
        .scan(2) { (extern, value) in
                extern + value// 10 + 2, 20 + 10 + 2, 30+20+10+2
        }.subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    }
    //MARK:过滤条件操作符
    func testFilteringConditionalOperators(){
        /*
        //filter : 仅从满足指定条件的可观察序列中发出那些元素
        Observable<Int>.of(1,2,3,4,5,6,7,8,9)
            .filter {
                $0 % 2 == 0
        }.subscribe(onNext: { print($0)})
        .disposed(by: disposeBag)
        //distinctUntilChanged: 抑制可观察序列发出的顺序重复元素
        Observable<String>.of("1","a","a","a","4","b","5","5","a")
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        //elementAt: 仅在可观察序列发出的所有元素的指定索引处发出元素
        Observable<Any>.of(1, "2", "ag", 10)
        .elementAt(3)
        .subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
        
        //single: 只发出可观察序列发出的第一个元素(或满足条件的第一个元素)。如果可观察序列发出多个元素，将抛出一个错误。
        Observable.of("MagiLi","KingWang")
//        .single()
        .single({ (str) in
            str.contains("King")
        })
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        */
        // take: 只从一个可观察序列的开始发出指定数量的元素。 上面signal只有一个序列 在实际开发会受到局限 这里引出 take 想几个就几个
        // takeLast: 仅从可观察序列的末尾发出指定数量的元素
        Observable.of("MagiLi","KingWang","MagiLi","KingWang")
//            .take(2)
            .takeLast(3)
            .subscribe(onNext: { (name) in
                print(name)
            }).disposed(by: disposeBag)
        // takeWhile: 只要指定条件的值为true，就从可观察序列的开始发出元素
        Observable.of(5,1,2,3,4,5,6)
            .takeWhile { $0 < 3 }
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)
        
        // takeUntil: 从源可观察序列发出元素，直到参考可观察序列发出元素
        // 这个要重点,应用非常频繁 比如我页面销毁了,就不能获取值了(cell重用运用)
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        sourceSequence.takeUntil(referenceSequence)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        sourceSequence.onNext("MagiLi...")
        sourceSequence.onNext("KingWang...")
        referenceSequence.onNext("stop...")
        sourceSequence.onNext("come on")// 条件一出来,下面就走不了
        
        
        
        Observable.of(1,2,3,1,5,6)
//        .skip(2)// skip: 跳过前2个
        .skipWhile({$0 < 3})// skipWhile: 跳过前面小于3的（中间的1不会被跳过）
        .subscribe({print($0)})
        .disposed(by: disposeBag)
        
        //skipUntil: 抑制从源可观察序列发出元素，直到参考可观察序列发出元素
        let sourceSkip = PublishSubject<String>()
        let referenceSkip =  PublishSubject<String>()
        sourceSkip.skipUntil(referenceSkip)
        .subscribe({print($0)})
        .disposed(by: disposeBag)
        
        sourceSkip.onNext("sourceSkip come on")//  不会打印
        referenceSkip.onNext("referenceSkip is better")// 参考序列发出元素后，源可观察序列才会执行
        
        sourceSkip.onNext("sourceSkip is later")// 打印
    }
    
    //MARK: 集合控制操作符
    func testMathematicalAggregateOperators(){
        //toArray: 将一个可观察序列转换为一个数组，将该数组作为一个新的单元素可观察序列发出，然后终止
        Observable.range(start: 1, count: 10)
        .toArray()
        .subscribe({ print($0) })
        .disposed(by: disposeBag)
        
        // reduce: 从一个设置的初始化值开始，然后对一个可观察序列发出的所有元素应用累加器闭包，并以单个元素可观察序列的形式返回聚合结果 - 类似scan
        Observable.of(10,100,1000)
            .reduce(1, accumulator: +)// 1 + 10 + 100 + 1000 = 1111
            .subscribe(onNext: { (num) in
                print(num)
            }).disposed(by: disposeBag)
        // concat: 以顺序方式连接来自一个可观察序列的内部可观察序列的元素，在从下一个序列发出元素之前，等待每个序列成功终止
        // 用来控制顺序
        let subject1 = BehaviorSubject<String>(value: "MajiLi")
        let subject2 = BehaviorSubject<String>(value: "King")
        let subject = BehaviorSubject(value: subject1)
        subject.asObserver()
        .concat()
        .subscribe({print($0)})
        .disposed(by: disposeBag)
        
        subject1.onNext("jjjjjj")
        subject.onNext(subject2)
        subject2.onNext("能打印吗？")
        subject1.onCompleted()// 必须要等subject1 完成了才能订阅到! 用来控制顺序 网络数据的异步
        subject2.onNext("必须能打印！！！")
    }
    
    //MARK: 从可观察对象的错误通知中恢复的操作符。
    func testErrorHandlingOperators() {
        /*
        // catchErrorJustReturn
        // 从错误事件中恢复，方法是返回一个可观察到的序列，该序列发出单个元素，然后终止
        let sequence = PublishSubject<String>()
        sequence.catchErrorJustReturn("fail")
        .subscribe({print($0)})
        .disposed(by: disposeBag)
        
        sequence.onNext("MagiLi")
        sequence.onError(self.lgError)//发送失败的序列,一旦订阅到位 返回我们之前设定的错误的预案
        
        // **** catchError
        // 通过切换到提供的恢复可观察序列，从错误事件中恢复
        let recoverySequence = PublishSubject<String>()
        recoverySequence.asObserver()
            .catchError { (error) -> Observable<String> in
                print("Error:", error)
                return recoverySequence// 获取到了错误序列-我们在中间的闭包操作处理完毕,返回给用户需要的序列(showAlert)
        }.subscribe({print($0)})
        .disposed(by: disposeBag)
        
        recoverySequence.onNext("llllll")
        recoverySequence.onError(self.lgError)
        */
        // retry: 通过无限地重新订阅可观察序列来恢复重复的错误事件
        var count = 1
        let retrySequence = Observable<Any>.create { (observer) -> Disposable in
            observer.onNext("MagiLi_retry")
            if count < 5 {
                print("error come on!")
                
                observer.onError(self.lgError)
                count += 1
            }
            observer.onNext("King_retry")
            observer.onCompleted()
            return Disposables.create()
        }
        
        retrySequence.asObservable()
        .retry(3)
        .debug()
        .subscribe({print($0)})
        .disposed(by: disposeBag)
    }
    
    /// 链接操作符
    func testConnectableOperators(){
        // 连接操作符的重要性
         testWithoutConnect()
//         testPushConnectOperators()
//         testReplayConnectOperators()
//         testMulticastConnectOperators()
    }
    //MARk: multicast
    func testMulticastConnectOperators() {
        // multicast : 将源可观察序列转换为可连接序列，并通过指定的主题广播其发射。
//        let subject = PublishSubject<Any>()
//        subject.mul
    }
    //MARk: replay
    func testReplayConnectOperators(){
        // replay: 将源可观察序列转换为可连接的序列，并将向每个新订阅服务器重放以前排放的缓冲大小
        // 首先拥有和publish一样的能力，共享 Observable sequence， 其次使用replay还需要我们传入一个参数（buffer size）来缓存已发送的事件，当有新的订阅者订阅了，会把缓存的事件发送给新的订阅者
//        let interval = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance).replay(5)
//        interval.subscribe({print(Date.time, "订阅1: 事件: \($0)")})
//        .disposed(by: disposeBag)
//
//        delay(2) {
//            _ = interval.connect()
//        }
//        delay(4) {
//            interval.subscribe(onNext: {print(Date.time, "订阅2: 事件: \($0)")})
//                .disposed(by: self.disposeBag)
//        }
//        delay(8) {
//               interval.subscribe(onNext: { print(Date.time,"订阅: 3, 事件: \($0)") })
//                   .disposed(by: self.disposeBag)
//        }
//
//        delay(20, closure:{
//            self.disposeBag = DisposeBag()
//        })
    }
    
    /// push - connect 将源可观察序列转换为可连接序列
    func testPushConnectOperators(){
        // **** push:将源可观察序列转换为可连接序列
        // 共享一个Observable的事件序列，避免创建多个Observable sequence。
        // 注意:需要调用connect之后才会开始发送事件
        
//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
//        interval.subscribe({
//            print("订阅1: 事件: \($0)")
//        }).disposed(by: disposeBag)
//
//        delay(2) {
//            _ = interval.connect()
//        }
//
//        delay(4) {
//            interval.subscribe({
//                print("订阅2: 事件: \($0)")
//            }).disposed(by: self.disposeBag)
//        }
//
//        delay(6) {
//            interval.subscribe({
//                print("订阅3: 事件: \($0)")
//            }).disposed(by: self.disposeBag)
//        }
//        delay(10, closure: {
//            self.disposeBag = DisposeBag()
//        })
        
    }
    /// 没有共享序列
    func testWithoutConnect() {
//        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        interval.subscribe({print("订阅1: 事件: \($0)")})
//            .disposed(by: disposeBag)
//        delay(2) {
//            interval.subscribe({print("订阅2: 事件: \($0)")})
//                .disposed(by: self.disposeBag)
//        }
//        
//        delay(4) {
//                self.disposeBag = DisposeBag()
//            }
        // 发现有一个问题:在延时3s之后订阅的Subscription: 2的计数并没有和Subscription: 1一致，而是又从0开始了，如果想共享，怎么办?
    }
    /// 延迟几秒执行
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}


struct CQPlayer {
    let score: BehaviorSubject<Int>
    init(score: Int) {
        self.score = BehaviorSubject(value: score)
    }
}
extension Date {
    static var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        return formatter.string(from: Date())
    }
}
