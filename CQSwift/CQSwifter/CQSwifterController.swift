//
//  CQSwifterController.swift
//  CQSwift
//
//  Created by llbt2019 on 2023/3/23.
//  Copyright © 2023 李超群. All rights reserved.
//

import UIKit

class CQSwifterController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let dataAray: [[String]] = [
        ["CQDesktopMenuController"],
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
//        if section == 0 {
//            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CQMainHeaderID") as? CQMainHeaderView
//            return header
//        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 50.0
//        } else {
            return 0.0
//        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //这是获取项目的名称
        var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String
        /**
         * 如果你的工程名字中带有“-” 符号  需要加上 replacingOccurrences(of: "-", with: "_") 这句代码把“-” 替换掉  不然还会报错 要不然系统会自动替换掉 这样就不是你原来的包名了 如果不包含“-”  这句代码 可以不加
         */
        //name = name?.replacingOccurrences(of: "-", with: "_")
        
        let stringArray = self.dataAray[indexPath.section]
        let string = stringArray[indexPath.row]
        let className = name! + "." + string
        //let aClass:AnyClass? = NSClassFromString(className)
        guard let aClass = NSClassFromString(className) as? UIViewController.Type else { return }
        
        let vc = aClass.init()
        self.navigationController?.pushViewController(vc, animated: true)
         
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle =  .none
        tableView?.register(CQMainCell.self, forCellReuseIdentifier: "CQMainCellID")
        //tableView?.register(CQMainHeaderView.self, forHeaderFooterViewReuseIdentifier: "CQMainHeaderID")
        self.view.addSubview(tableView!)
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.bounds
    }
    
}

