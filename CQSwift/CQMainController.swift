//
//  CQMainController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/20.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit


@available(iOS 11.0, *)
class CQMainController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?

    lazy var dataAray : [NSArray] = {
        () -> [NSArray] in
        return [["collectionView", "tableView"]]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor.cyan
        tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView?.register(CQMainCell.self, forCellReuseIdentifier: "CQMainCellID")
        tableView?.register(CQMainHeaderView.self, forHeaderFooterViewReuseIdentifier: "CQMainHeaderID")
        self.view.addSubview(tableView!)
      /*
        
        let arr = [5,3,4]
        let arrR = arr.map { (a) -> Int in
            return a*2
        }
        
        print(arrR)
        let sortedArray:[Any?] = [2,3,5,6,7,"we"]
        let resF = sortedArray.map{ (a) -> Any? in
            return a
        }
        print(resF)
        let result = sortedArray.compactMap { (a) -> Any? in
            return a
        }
        print(result)
//
        _ = arr.sorted { (a, b) -> Bool in
            return a > b
        }
        print(sortedArray) //[7, 6, 5, 3, 2]
        
        let sortArray = arr.sorted(by: {$0 < $1})
        print(sortArray) //[2, 3, 5, 6, 7]
        */
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataAray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataAray[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQMainCellID", for: indexPath) as! CQMainCell
        cell.title = self.dataAray[indexPath.section][indexPath.row] as? NSString
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CQMainHeaderID")
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CQMainHeaderID")
        return footer
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let url = URL(string: "other:")
//        if UIApplication.shared.canOpenURL(url!) {
//            UIApplication.shared.openURL(url!)
//        } else {
//            print("kfdlskkkkkkk")
//        }
        
        switch indexPath.section {
        case 0:
            do {
            if indexPath.row == 0 {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = UICollectionView.ScrollDirection.vertical
                let collectionVC = CQCollectionViewController.init(collectionViewLayout: layout)
                self.navigationController?.pushViewController(collectionVC, animated: true)
            } else if indexPath.row == 1 {
                let tableViewVC = CQTableViewController()
                self.navigationController?.pushViewController(tableViewVC, animated: true)
            }
        }
        default:
            break
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.bounds
    }
}
