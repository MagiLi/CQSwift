//
//  CQMainController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/20.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

struct PHError:Error {
    var desc = ""
    var code = ""
    var localizedDescription: String{
        return desc
    }
    init(_ desc:String) {
        self.desc = desc
    }
}

//extension PHError: LocalizedError {
//    var errorDescription: String? {
//        return self.desc
//    }
//}


@available(iOS 11.0, *)
class CQMainController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?

    lazy var dataAray : [NSArray] = {
        () -> [NSArray] in
        return [["collectionView", "tableView"],["九宫格手势解锁"],["JS交互"],["Loading"]]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.floatHanler()
        
        
        tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView?.register(CQMainCell.self, forCellReuseIdentifier: "CQMainCellID")
        tableView?.register(CQMainHeaderView.self, forHeaderFooterViewReuseIdentifier: "CQMainHeaderID")
        self.view.addSubview(tableView!)
    
        //self.testMap()
//        DispatchQueue.main.async {
//            self.testError()
//        }
    }
    //MARK: 精度计算不准确处理
    func floatHanler() {
        let value1 = "12300.02"
        let value2 = "20230"
        let faloat1 = Float(value1) ?? 0.0
        let faloat2 = Float(value2) ?? 0.0
        print("faloat1: \(faloat1) \n \(value2)")
        let faloat1String = String(format: "%.2f", faloat1)
        let faloat2String = String(format: "%.2f", faloat2)
        print("faloat1String: \(faloat1String) \n \(faloat2String)")
        
        let detal1 = faloat2 - faloat1
        let detal2 = CGFloat(faloat2) - CGFloat(faloat1)
        print("detal1: \(detal1) \n detal2: \(detal2)")
        /**
         初始化方法
         @param roundingMode 舍入方式
         @param scale 小数点后舍入值的位数
         @param exact 精度错误处理
         @param overflow 溢出错误处理
         @param underflow 下溢错误处理
         @param divideByZero 除以0的错误处理
         @return NSDecimalNumberHandler对象
   
         */

        let smallQuotaDecimal = NSDecimalNumber.init(string: value1)
        let bigQuotaDecimal = NSDecimalNumber.init(string: value2)
//        let handle = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
//        let loanBalanceQuota = bigQuotaDecimal.subtracting(smallQuotaDecimal, withBehavior: handle)
        let loanBalanceQuota = bigQuotaDecimal.subtracting(smallQuotaDecimal)
        print("\(loanBalanceQuota.doubleValue)")
    }
    func testError() {
        var error = PHError("你刷的")
        error.code = "1001"
        var message = error.desc + error.code + error.localizedDescription
        let sureAction = UIAlertAction(title: "确定", style:.default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let  alertVC = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    func testMap() {
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

    }
    //MARK: UITableViewDataSource
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
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CQMainHeaderID")
            return header
        }
        return UITableViewHeaderFooterView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    //MARK: UITableViewDelegate
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
            if indexPath.row == 0 {
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = UICollectionView.ScrollDirection.vertical
                let collectionVC = CQCollectionViewController.init(collectionViewLayout: layout)
                self.navigationController?.pushViewController(collectionVC, animated: true)
            } else if indexPath.row == 1 {
                let tableViewVC = CQTableViewController()
                self.navigationController?.pushViewController(tableViewVC, animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                let gridLockVC = CQGridLockController()
                self.navigationController?.pushViewController(gridLockVC, animated: true)
            }
        case 2:
            let vc = CQWebViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = CQLoadingController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.bounds
    }
}
