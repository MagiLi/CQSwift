//
//  CQNestedTableVC.swift
//  CQSwift
//
//  Created by 李超群 on 2022/5/18.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQNestedTableVC: UIViewController {
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
    }
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        self.tableView.frame = self.view.bounds
    }
    lazy var tableView: CQNestedMainTableView = {
        let view = CQNestedMainTableView(frame: .zero, style: .grouped)
        return view
    }()

}
