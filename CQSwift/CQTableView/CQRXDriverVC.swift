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

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupUI()
//        testDriver()
        
//        testCombinationOperation()
//        testTransformingOperation()
//        testFilteringConditionalOperators()
        testMathematicalAggregateOperators()
    }
    
    //MARK:testDriver
    func testDriver() -> Void {
        let observableField = self.textField.rx.text.orEmpty
            .asDriver()
            .flatMap {
                return self.getSimulationData(inputText: $0)
                .asDriver(onErrorJustReturn: "===== error =====")
        }
        observableField.map {
            "length: \(($0 as! String).count)"
        }
        .drive(self.textLabel.rx.text)
        .disposed(by: disposeBag)
    }

    func getSimulationData(inputText: String) -> Observable<Any>{
        print("发起线程 \(Thread.current)")
        let observable = Observable<Any>.create { (anyObservable) -> Disposable in
            if inputText == "123" {
                anyObservable.onError(NSError.init(domain: "com.driver.cn", code: 10086, userInfo: nil))
            }
            DispatchQueue.global().async {
                print("回调线程 \(Thread.current)")
                anyObservable.onNext("已经输入:\(inputText)")
                anyObservable.onCompleted()
            }
            return Disposables.create()
        }
        return observable
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let textlabelFrame = CGRect(x: 20.0, y: 120.0, width: 80.0, height: 50.0)
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
        
    }
}


struct CQPlayer {
    let score: BehaviorSubject<Int>
    init(score: Int) {
        self.score = BehaviorSubject(value: score)
    }
}
