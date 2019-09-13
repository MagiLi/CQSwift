//
//  CQRXSwifObservableVC.swift
//  CQSwift
//
//  Created by 李超群 on 2019/9/13.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

class CQRXSwifObservableVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    // MARK: - setupUI
    func setupUI() {
        self.title = "Observable创建"
        self.view.backgroundColor = UIColor.white
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
