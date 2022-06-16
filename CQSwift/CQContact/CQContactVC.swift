//
//  CQContactVC.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/16.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit

class CQContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    fileprivate let dataArray = ["通讯录列表", "新建联系人", "添加到现有联系人"]
    var listViewModel: CQContactListViewModel?
    var newViewModel: CQContactNewViewModel?
    var editViewModel: CQContactAddViewModel?
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CQMainCellID", for: indexPath) as! CQMainCell
        cell.title = self.dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = self.dataArray[indexPath.row]
        if title == "通讯录列表" {
            //CQContactManager.shared.showContacts(vc: self)
            let model = CQContactListViewModel(controller: self)
            model.showContacts()
            model.phoneBlock = { phone in
                print("listViewModel: \(phone)")
            }
            model.cancleBlock = {
                print("listViewModel: cancel")
            }
            self.listViewModel = model
        } else if title == "新建联系人" {
            //CQContactManager.shared.creatContact(vc: self)
            let model = CQContactNewViewModel(controller: self)
            model.phone = "8990890"
            model.creatContact()
            model.newContactSucc = { contact in
                print("newViewModel: \(contact.familyName)")
            }
            model.newContactCancel = {
                print("newViewModel: cancel")
            }
            self.newViewModel = model
        } else if title == "添加到现有联系人" {
            let model = CQContactAddViewModel(controller: self)
            model.phone = "1232334324"
            model.addToExistingContacts()
            model.addSucc = { contact in
                print("addViewModel:  \(contact.familyName)")
            }
            model.addCancel = {
                print("addViewModel: cancel")
            }
            self.editViewModel = model
            //CQContactManager.shared.addToExistingContacts(vc: self)
        }
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    //MARK: lazy
    lazy var tableView: UITableView = {
        let tableV = UITableView.init(frame: .zero, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.separatorStyle =  .none
        tableV.register(CQMainCell.self, forCellReuseIdentifier: "CQMainCellID") 
        return tableV
    }()
    
    deinit {
        print("deinit - CQContactVC")
    }
}
