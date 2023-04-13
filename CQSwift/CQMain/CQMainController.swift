//
//  CQMainController.swift
//  CQSwift
//
//  Created by 李超群 on 2019/8/20.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit
import SwiftUI

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
class CQMainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    var tableView : UITableView?

    fileprivate let dataAray: [[String]] = [
        ["collectionView", "tableView", "tableView嵌套", "自定义ScrollView", "饱和度混合模式", "SwiftUI"],
        ["九宫格手势解锁", "日历", "字幕滚动"],
        ["JS交互", "Swifter-server"],
        ["Loading", "指针", "手机通讯录"],
        ["渐变"],
        ["Metal"],
        ["Third demo"]
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.floatHanler()
        //CQGrayManager.shared.addGrayView()
        
        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle =  .none
        tableView?.register(CQMainCell.self, forCellReuseIdentifier: "CQMainCellID")
        tableView?.register(CQMainHeaderView.self, forHeaderFooterViewReuseIdentifier: "CQMainHeaderID")
        self.view.addSubview(tableView!)
        
        
//        _ = self.getNowTimeTimestamp()
        
        // 这样写时间跟北京时间相同
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        formatter.locale = Locale.init(identifier: "zh_Hans_CN")
//        formatter.calendar = Calendar.init(identifier: .iso8601)
//        formatter.timeZone = TimeZone.current
//        let dateStr = formatter.string(from: date)
//        guard let newDate = formatter.date(from: dateStr) else { return }

//        // 错误写法
//        let newDate = Date(timeInterval: 60*60*8, since: Date())
//        let stamp = newDate.timeIntervalSince1970
//        print("stamp: \(stamp)")
//        let stampString = "\(u_long(stamp))"
//        print("stampString: \(stampString)")
  
        // 这样写时间跟北京时间相差差8小时（需要用DateFormatter设置时区）
//        let newDate = Date()
//        print("date: \(newDate)")
//        let stamp = newDate.timeIntervalSince1970
        
//        print("dateTime: \(stamp)")
        
//        _ = self.date(stampTime: stampString)
        // 本地通知测试
        //NotificationCenter.default.addObserver(self, selector: #selector(receivewalletNoti(noti:)), name: NSNotification.Name(rawValue: "noti_test"), object: nil)
    }
    @objc fileprivate func receivewalletNoti(noti:Notification){
        if let info = noti.object as? [String:Any] {
            print(info)
            if let tt = info["notiType"] as? Int {
                print(tt)
            }
        }
    }
    func date(stampTime:String) -> Date? {
        //转换为时间
        guard let timeInterval:TimeInterval = TimeInterval(stampTime) else { return nil }
        print("timeInterval:\(timeInterval)")
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        formatter.locale = Locale.init(identifier: "zh_Hans_CN")
        formatter.calendar = Calendar.init(identifier: .iso8601)
        let dateStr = formatter.string(from: date)
        print("dateStr: \(dateStr)")
        return date as Date
    }
    func getNowTimeTimestamp() -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        let timezone = TimeZone.init(identifier: "Asia/Beijing")
//        formatter.timeZone = timezone
//        guard let dateTime = formatter.date(from: NSDate()) else { return }
        let dateTime = NSDate.init()
        //这里是秒，如果想要毫秒timeIntervalSince1970 * 1000
        let timeSp = String(format: "%d", dateTime.timeIntervalSince1970)
        print("dateTime: \(dateTime.timeIntervalSince1970)")
        print(timeSp)
        return timeSp
    }
 
    func testArray() {
        let obj = 5
        var array = [10, 30]
        array.insert(obj, at: 2)
        print("--------")
        print(array)
    }
    func testFont() {
        UIFont.familyNames.forEach {
            print("## Font Family Name: \($0)")
            //let familyName = "## Font Family Name: \($0) \n"
            UIFont.fontNames(forFamilyName: $0).forEach {
                print("* **Font Name:** \($0)")
                //let name = "* **Font Name:** \($0) \n"
            }
            //let boundry = "\n ============================"
            print("\n ============================")
        }
    }
    func testRangeToNSRange() {
        let fullString = "大开发高科技啊刷卡时"
        let subString = "科技"
        
        let range = fullString.range(of: subString)!
        let length = fullString.distance(from: range.lowerBound, to: range.upperBound)
        let location = fullString.distance(from: fullString.startIndex, to: range.lowerBound)
        print("location: \(location) length: \(length)")
        let nsRange = NSMakeRange(location, length)
         

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
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = UICollectionView.ScrollDirection.vertical
                let collectionVC = CQCollectionViewController.init(collectionViewLayout: layout)
                self.navigationController?.pushViewController(collectionVC, animated: true)
            } else if indexPath.row == 1 {
                let tableViewVC = CQTableViewController()
                self.navigationController?.pushViewController(tableViewVC, animated: true)
            } else if indexPath.row == 2 {
                let nestedVC = CQNestedTableVC()
                self.navigationController?.pushViewController(nestedVC, animated: true)
            } else if indexPath.row == 3 {
                let scrollVC = CQCustomScrollVC()
                self.navigationController?.pushViewController(scrollVC, animated: true)
            } else if indexPath.row == 4 { //"饱和度混合模式"
                let vc = CQSaturationController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 5 {
                // 在swift中使用swiftUI
                let landmarkVC = UIHostingController(rootView: CQSContentView())
                if #available(iOS 16.0, *) {
                    landmarkVC.sizingOptions = .intrinsicContentSize
                } else {
                    // Fallback on earlier versions
                }
                landmarkVC.modalPresentationStyle = .fullScreen
                self.present(landmarkVC, animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                let gridLockVC = CQGridLockController()
                self.navigationController?.pushViewController(gridLockVC, animated: true)
            } else if indexPath.row == 1 {
                CQLoadingManager.shared.show()
                CQCalenderEventManager.requestEventAuthorization(grantBlock: {
                    CQLoadingManager.shared.dismiss()
                    let calendarVC = CQCalendarController()
                    self.navigationController?.pushViewController(calendarVC, animated: true)
                }, ungrantBlock: {
                    CQLoadingManager.shared.dismiss()
                })
            
            } else if indexPath.row == 2 {
                let vc = CQTextScrollVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if indexPath.row == 0 {
                let vc = CQWebViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = CQSwifterController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            if indexPath.row == 0 {
                let vc = CQLoadingController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                let vc = CQIndicatorVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                let vc = CQContactVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 4:
            let vc = CQGradientController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = CQMetalMainController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = THMainController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func localNoti() {
        let center = UNUserNotificationCenter.current()
        //center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if granted {
                print("发通知")
                center.delegate = self
                center.getNotificationSettings { settings in }
                let content = UNMutableNotificationContent()
                content.title = "迪佛舒服开始了"
                content.body = "khjjjkhjfklsfsl"
                content.sound = UNNotificationSound.default
                
                // 通知下拉时候的动作
                let action = UNNotificationAction(identifier: "action", title: "进入应用", options: UNNotificationActionOptions.foreground)
                let clearAction = UNNotificationAction(identifier: "clearaction", title: "忽略", options: UNNotificationActionOptions.destructive)
                let category = UNNotificationCategory(identifier: "categoryIdentifier", actions: [action,clearAction], intentIdentifiers: [], options: [])
                center.setNotificationCategories([category])
                
                let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                
                let requestidentifier = "requestidentifier"
                let request = UNNotificationRequest(identifier: requestidentifier, content: content, trigger: timeTrigger)
                // 将通知请求添加到发送中心
                center.add(request) { (error: Error?) in
                    print(error?.localizedDescription ?? "--")
                }
            } else {
                print(error?.localizedDescription)
            }
        } 
    }
    
    //MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.bounds
    }
    
    //MARK: UNUserNotificationCenterDelegate
    // 将要通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
          print("willPresent")
    }
        
    // 已经完成推送
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
          print("didReceive")
          completionHandler()
    }
}
