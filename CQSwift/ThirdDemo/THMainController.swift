//
//  THMainController.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/7/20.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class THMainController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let dataAray: [[String]] = [
        ["picture", "scrollDemo"],
    ]
    var tableView : UITableView?
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataAray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataAray[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQMainCellID", for: indexPath) as! CQMainCell
        cell.title = self.dataAray[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CQMainHeaderID") as? CQMainHeaderView
            return header
        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50.0
        } else {
            return 0.0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) 
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let tableViewVC = THPictureController()
                self.navigationController?.pushViewController(tableViewVC, animated: true)
            } else if indexPath.row == 1 {
                let tableViewVC = THScrollController()
                self.navigationController?.pushViewController(tableViewVC, animated: true)
            }
        default:
            break
        }
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle =  .none
        tableView?.register(CQMainCell.self, forCellReuseIdentifier: "CQMainCellID")
        tableView?.register(CQMainHeaderView.self, forHeaderFooterViewReuseIdentifier: "CQMainHeaderID")
        self.view.addSubview(tableView!)
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.bounds
    }
    
}