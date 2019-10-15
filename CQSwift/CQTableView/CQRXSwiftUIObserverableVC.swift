//
//  CQRXSwiftUIObserverableVC.swift
//  CQSwift
//
//  Created by 李超群 on 2019/9/21.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CQRXSwiftUIObserverableVC: UIViewController {

    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var boyBtn: UIButton!
    @IBOutlet weak var girlBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var slideView: UISlider!
    
    @IBOutlet weak var textField: UITextField!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateOB = self.datePick.rx.date
            .map { (date) in
                self.isValiad(date)
        }
        dateOB.map { (valiad) -> UIColor in
//            $0 ? UIColor.red : UIColor.lightGray
                valiad ? UIColor.red : UIColor.lightGray
            }.subscribe(onNext: {[weak self] (color) in
                self?.datePick.layer.backgroundColor = color.cgColor
            }).disposed(by: disposeBag)

        
        let sexOB = Variable<Sex>(Sex.unknow)
        self.boyBtn.rx.tap.map {Sex.boy}
        .bind(to: sexOB)
        .disposed(by: disposeBag)
        self.girlBtn.rx.tap.map {Sex.girl}
        .bind(to: sexOB)
        .disposed(by: disposeBag)
        sexOB.asObservable().subscribe(onNext: {[weak self] (sex) in
            switch sex {
            case .boy:
                self?.boyBtn.isSelected = true
                self?.girlBtn.isSelected = false
            case .girl:
                self?.boyBtn.isSelected = false
                self?.girlBtn.isSelected = true
            case .unknow:
                self?.boyBtn.isSelected = false
                self?.girlBtn.isSelected = false
            }
            
        }).disposed(by: disposeBag)
        
        
        let sexValiableOB = sexOB.asObservable().map{($0 == .unknow) ? false : true}
//        Observable.combineLatest(dateOB, sexValiableOB){($0 && $1) ? 0.5 : 1.0}
//            .bind(to: updateBtn.rx.alpha)
//            .disposed(by: disposeBag)
        let combineOB = Observable.combineLatest(dateOB, sexValiableOB){$0 && $1}
        combineOB.subscribe(onNext: {[weak self] (enable) in
            self?.updateBtn.isEnabled = enable
            self?.updateBtn.alpha = enable ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        //
        self.switchBtn.rx.isOn.map {$0 ? 0.25 : 0.0}
        .bind(to: slideView.rx.value)
        .disposed(by: disposeBag)
        
        self.slideView.rx.value.map{($0 <= 0) ? false : true}
        .bind(to: switchBtn.rx.isOn)
        .disposed(by: disposeBag)
        
        // 两次1.初始化来一次 2.开始编辑的时候进来一次
        self.textField.rx.text.subscribe (onNext: { (text) in
            print("text: \(text as Any)")
        }).disposed(by: disposeBag)
        
    }
    
    func isValiad(_ date: Date) -> Bool {
        let calendar = NSCalendar.current
       let compare = calendar.compare(date, to: Date.init(), toGranularity: Calendar.Component.day)
        return compare == .orderedAscending
    }

    deinit {
        print(self)
    }
}

enum Sex {
    case unknow
    case boy
    case girl
}
