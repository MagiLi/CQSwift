//
//  CQTableViewController.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/9/28.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit

class CQGridLockController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "手势解锁"
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "reuseIdentifier")
        if indexPath.row == 0 {
            cell.textLabel?.text = "创建手势密码"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "解锁手势密码"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "删除手势密码"
        }
        return cell
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let createVC = CQGridLockCreateVC()
            createVC.modalPresentationStyle = .fullScreen
            createVC.lockType = .create
            self.present(createVC, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let createVC = CQGridLockCreateVC()
            createVC.modalPresentationStyle = .fullScreen
            createVC.lockType = .unlock
            self.present(createVC, animated: true, completion: nil)
        }
    }
}
