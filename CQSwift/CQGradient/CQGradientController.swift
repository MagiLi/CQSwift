//
//  CQGradientController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/21.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQGradientController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.imgView)
        self.view.addSubview(self.gradientView)
        self.view.addSubview(self.gradientView1)
        self.view.addSubview(self.lineView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.frame = CGRect(x: 0.0, y: 100.0, width: 100.0, height: 100.0)
        self.gradientView1.frame = CGRect(x: 0.0, y: 210.0, width: 100.0, height: 100.0)
        self.imgView.frame = self.gradientView1.frame
        
        self.lineView.frame = CGRect(x: 0.0, y: self.gradientView1.frame.maxY, width: 100.0, height: 100.0)
    }
    
    lazy var gradientView:CQGradientView = {
        let view = CQGradientView()
        return view
    }()
    lazy var gradientView1:CQGradientView1 = {
        let view = CQGradientView1()
        return view
    }()
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "heart")
        return view
    }()
    lazy var lineView: CQGradientView2 = {
        let view = CQGradientView2()
        return view
    }()
}
