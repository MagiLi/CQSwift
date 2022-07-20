//
//  CQCustomScrollVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/7/6.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQCustomScrollVC: UIViewController {

    override func loadView() {
        self.view = self.scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    lazy var scrollView: CQCustomScrollView = {
        let view = CQCustomScrollView()
        return view
    }()
}
