//
//  CQRXSwifObservableVC.swift
//  CQSwift
//
//  Created by 李超群 on 2019/9/13.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CQRXSwifObservableVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.generateObservable()
    }
    // MARK: - setupUI
    func setupUI() {
        self.title = "Observable创建"
        self.view.theme_backgroundColor = ["#C6C5C5", "#C6C5C5"];
//        self.view.backgroundColor = UIColor.white
       
    }
    func emptyObservable() {
        // 序列原本int型，空序列（empty）只能onCompleted
        let observableEmpty = Observable<Int>.empty()
        _ = observableEmpty.subscribe(onNext: { (number) in
            print("subscribe:", number)
        }, onError: { (error) in
            print("error:", error)
        }, onCompleted: {
            print("finished")
        }) {
            print("dealloc empty")
        }
    }
    
    func justObservable() {
        let array = ["jjjjj", "kkkkkk"]
        let observableJust = Observable<[String]>.just(array)
        observableJust.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
        
        _ = observableJust.subscribe(onNext: { (string) in
            print(string)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("finished")
        }) {
            print("dealloc just")
        }
    }
    // MARK: - ofObservable
    func ofObservable() {
        Observable<[String]>.of(["gggg", "oooo"])
            .subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
        
        _ = Observable<[String:Any]>.of(["person":"li", "sex":"boy", "age":18])
            .subscribe(onNext: { (dict) in
                print(dict)
            }, onError: { (error) in
                print("error:", error)
            }, onCompleted: {
                print("finished")
            }) {
                print("dealloc of")
        }
    }
    // MARK: fromObservable(optional更安全)
    func fromObservable() {
        Observable.from(optional: ["nini", "jjjj"])
            .subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
    }
    
    func deferObservable() {
        var isOddNumber = true
        _ = Observable<Int>.deferred { () -> Observable<Int> in
            isOddNumber = !isOddNumber
            if isOddNumber {
                return Observable.of(1,3,5,7,9)
            }
            return Observable.of(0,2,4,6,8)
            }.subscribe { (event) in
                print(event)
        }
    }
    
    func rangeObservable() {
        Observable.range(start: 2, count: 10)
            .subscribe { (event) in
                print(event)
        }.disposed(by: disposeBag)
    }
    
    func generateObservable() {
//        Observable<Int>.generate(initialState: 5, condition: { (num) -> Bool in
//            num < 10
//        }) { (total) -> Int in
//            return total + 2
//            }.subscribe { (event) in
//                print(event)
//        }.disposed(by: disposeBag)
        
//        Observable<Int>.generate(initialState: 5,
//                                 condition: {$0 < 10},// 条件
//                                 iterate: {$0 + 2})// 重复做
//            .subscribe { (event) in
//                print(event)
//        }.disposed(by: disposeBag)
        
        var array = ["string0", "string1", "string2", "string3", "string4", "string5"]
        Observable<Int>.generate(initialState: 0, condition: { (temp) -> Bool in
            temp < array.count
        }) { (add) -> Int in
            add + 1
            }.subscribe(onNext: { (index) in
                print("arrayString:", array[index])
            }) {
                print("deallo generate")
        }
        
    }
}
