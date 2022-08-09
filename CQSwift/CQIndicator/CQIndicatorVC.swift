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
        self.view.backgroundColor = .white
        self.view.addSubview(self.indicatoreView)
//        self.view.addSubview(self.circleView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        let indicatoreViewW:CGFloat = 216.0
        let indicatoreViewH:CGFloat = 177.0
        self.indicatoreView.frame = CGRect(x: 50.0, y: 150.0, width: indicatoreViewW, height: indicatoreViewH)
        self.circleView.frame = CGRect(x: 50.0, y: self.indicatoreView.frame.maxY, width: indicatoreViewW, height: indicatoreViewH)
    }
    
    lazy var indicatoreView: CQIndicatorGradientView = {
        let view = CQIndicatorGradientView()
        return view
    }()
    
    lazy var circleView: CQGradientRingView = {
        let view = CQGradientRingView()
        return view
    }()
}
