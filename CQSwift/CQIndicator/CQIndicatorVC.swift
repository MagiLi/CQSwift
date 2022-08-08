//
//  CQIndicatorVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/8/8.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQIndicatorVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.indicatoreView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.indicatoreView.frame = self.view.bounds
    }
    
    lazy var indicatoreView: CQIndicatorView = {
        let view = CQIndicatorView()
        return view
    }()
}
