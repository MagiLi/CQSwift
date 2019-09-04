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

        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            print("indexPath \(indexPath.row)")
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("finished")
        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CQDataModel.self).subscribe(onNext:{ (model) in
            print(model)
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
        // 1.创建序列
        // 创建AnonymousObservable(->Producer->Observable) 类遵循协议 ObservableType(->ObservableConvertibleType)
        // AnonymousObservable类保存subscribe
        let ob = Observable<Any>.create { (observer) -> Disposable in
            observer.onNext("走起")
            return Disposables.create()
        }
        // 2. ob(Observable类型) 订阅序列
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
