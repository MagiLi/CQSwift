//
//  CQTableViewController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/24.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let cellID = "CQTableViewCellID"

class CQTableViewController: UIViewController {
    let disposeBag = DisposeBag()
    var tableView : UITableView!
    
    var timer = Timer()
    var gcdTimer : DispatchSourceTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "tableView"
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.register(CQTableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        

        let items = Observable.just(CQTableViewCellModel().array)
        items.bind(to: self.tableView.rx.items) { (tableView, row, model) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? CQTableViewCell
            cell?.titlteLabel?.text = model.title as String?
            cell?.nameLabel?.text = model.subTitle as String?
            return cell!

        }.disposed(by: disposeBag)

        //MARK:itemSelected
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            print("indexPath \(indexPath.row)")
            switch indexPath.row {
            case 0:
                let observableVC = CQRXSwifObservableVC()
                self.navigationController?.pushViewController(observableVC, animated: true)
                break
            default:
                break
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("finished")
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CQDataModel.self).subscribe(onNext:{ (model) in
            print(model)
        }).disposed(by: disposeBag)
        
        
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { (num) in
            print(num)
        }).disposed(by: disposeBag)
        
    }
    
    @objc func timefire() {
        print("timer coming in!")
    }
    
    func timerTest() {
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(timefire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)

    }
    func gcdTimerTest()  {
        gcdTimer = DispatchSource.makeTimerSource()
        gcdTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1))
        gcdTimer?.setEventHandler(handler: {[weak self] in
            
            self?.timefire()
        })
        gcdTimer?.resume()
    }
    
    //MARK: 订阅信号
    func rxSwiftSubscribe() {
        /* 1.创建序列
         Observable<Any>.create
         ->AnonymousObservable(->Producer->Observable) 类遵循协议 ObservableType(->ObservableConvertibleType)
         ->self._subscribeHandler = subscribeHandler：持有subscribeHandler
        */
        // 创建AnonymousObservable(->Producer->Observable) 类遵循协议 ObservableType(->ObservableConvertibleType)
        // AnonymousObservable类保存subscribe
        let ob = Observable<Any>.create { (observer) -> Disposable in
            observer.onNext("走起")
            /*3.发送信号
             observer.onNext("走起")：observer是anyObserver类
             ->self.observer(event)：self是anyObserver类，observer是持有的anonymousObservableSink.on
             ->anonymousObservableSink.on
             ->.next/.complete/.error
             ->self.forwardOn(event)：anonymousObservableSin父类sink的方法
             ->self._observer.on(event):_observer是anonymousObservableSink持有的anonymousObserver
             ->anonymousObserver.on:父类ObserverBase的.on
             ->.next/.complete/.error
             ->self.onCore(event):anonymousObserver类内方法的实现
             ->self._eventHandler(event):_eventHandler就是AnonymousObserver初始化时持有的尾随闭包
             ->.next/.complete/.error
             ->onNext/onCompleted/onError:这些就是第四步相应信号的闭包函数
             ->进入响应
            */
            return Disposables.create()
        }
        /* 2. ob(Observable类型) 订阅序列
         ob.subscribe
         ->AnonymousObserver:初始化observer持有尾随闭包函数
         ->self.asObservable().subscribe(observer)：AnonymousObserver的父类Producer内的.subscribe函数
         ->.run:AnonymousObserver类内添加了实现
         ->AnonymousObservableSink(observer: observer, cancel: cancel):初始化sink
         ----->self._observer = observer：父类sink持有observer和cancel
              self._cancel = cancel
         ----->AnonymousObservableSink类实现一个.on函数
         ->sink.run(self):self传入的是当前序列AnonymousObservable
         ->parent._subscribeHandler(AnyObserver(self)):_subscribeHandler就是第一步AnonymousObservable持有的subscribeHandler
         ----->AnyObserver(self):AnyObserver是一个结构体,self是AnonymousObservableSink
         -------------->self.observer = observer.on:持有AnonymousObservableSink.on
         ->唤起第三步，发送信号
         */
        // 创建临时工作区asObservable()
        _ = ob.subscribe(onNext: { (content) in
            print("订阅的内容：\(content)")
        }, onError: { (Error) in
            print("error")
        }, onCompleted: {
            print("完成")
        }) {
            print("销毁")
        }
    }

}

class CQTableViewCell: UITableViewCell {
    
    var titlteLabel:UILabel?
    var nameLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titlteLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: self.contentView.bounds.height))
        self.contentView.addSubview(self.titlteLabel!)
        
        self.nameLabel = UILabel(frame: CGRect(x: self.titlteLabel!.bounds.maxX, y: 0, width: 100, height: self.contentView.bounds.height))
        self.contentView.addSubview(self.nameLabel!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getvalue(titleStr:String,nameStr:String){
        self.titlteLabel?.text = titleStr
        self.nameLabel?.text = nameStr
    }
    
}
