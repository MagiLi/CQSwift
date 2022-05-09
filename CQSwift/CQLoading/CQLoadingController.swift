//
//  CQLoadingController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/5/9.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQLoadingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.loadingView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.loadingView.frame = CGRect(x: 0.0, y: 100.0, width: CQScreenW, height: 200.0)
    }
    lazy var loadingView: CQLoadingView = {
        let frame = CGRect(x: 0.0, y: 100.0, width: CQScreenW, height: 200.0)
        let view = CQLoadingView(frame: frame)
        view.backgroundColor = .lightGray
        return view
    }()
}
