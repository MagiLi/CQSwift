//
//  CQDispatchVC.swift
//  CQSwift
//
//  Created by 李超群 on 2019/10/31.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CQDispatchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.button)
        
        DispatchQueue.global().async {
            self.button.rx.tap
                .subscribe(onNext: { () in
        
                    print("currentThread: \(Thread.current)")
                })
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.button.frame = CGRect(x: 100.0, y: 100.0, width: 100.0, height: 80.0)
    }
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("clicked", for: .normal)
        return btn
    }()
}
