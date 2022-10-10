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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.frame = CGRect(x: 0.0, y: 100.0, width: 100.0, height: 100.0)
        self.gradientView1.frame = CGRect(x: 0.0, y: 210.0, width: 100.0, height: 100.0)
        self.imgView.frame = self.gradientView1.frame
         
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
}
