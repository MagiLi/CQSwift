//
//  CQTextScrollVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/25.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQTextScrollVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(self.textScrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let x:CGFloat = 20.0
        let width = self.view.frame.width - x * 2.0
        self.textScrollView.frame = CGRect(x: x, y: 100.0, width:width, height: 30.0)
    }
    
    lazy var textScrollView: CQTextScrollView = {
        let view = CQTextScrollView()
        return view
    }()
}
