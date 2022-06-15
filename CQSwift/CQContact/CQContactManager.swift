//
//  CQContactManager.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/15.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CQContactManager: NSObject, CNContactPickerDelegate {
    
    static let shared : CQContactManager = {
        let manager = CQContactManager()
        return manager
    }()
    
    var phoneBlock:((_ phoneNum:String)->())?
    var cancleBlock:(()->())?
    
    func creatContact() {
        // 第一次运行的时候，会获取通讯录的授权（对通讯录进行操作，有权限设置）
        let contact = CNMutableContact()
        
        // 1、添加姓名（姓＋名）
        contact.givenName = "san";
        contact.familyName = "wangg";
        
        // 2、添加职位相关
        contact.organizationName = "公司名称"
        contact.departmentName = "开发部门"
        contact.jobTitle = "工程师"
        
        // 3、这一部分内容会显示在联系人名字的下面，phoneticFamilyName属性设置的话，会影响联系人列表界面的排序
        //    contact.phoneticGivenName = @"GivenName";
        //    contact.phoneticFamilyName = @"FamilyName";
        //    contact.phoneticMiddleName = @"MiddleName";
        
        // 4、备注
        contact.note = "同事"
        // 5、头像
        contact.imageData = UIImage(named: "head_nor")?.pngData()
        // 6、设置email
        let email = CNLabeledValue(label: CNLabelEmailiCloud, value: "feifei@163.com" as NSString)
        contact.emailAddresses = [email]
        // 8、添加电话
        let mobileNumber = CNPhoneNumber(stringValue: "18510002000")
        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                         value: mobileNumber)
        contact.phoneNumbers = [mobileValue]
        
        // 9、添加urlAddresses,
        let addressValue = NSString(string: "[http://baidu.com](http://baidu.com)")
        let address = CNLabeledValue(label: CNLabelURLAddressHomePage, value: addressValue)
        contact.urlAddresses = [address]
        
        
        // 10、添加邮政地址
        let postal = CNMutablePostalAddress()
        postal.city = "北京"
        postal.country =  "中国"
        let homePostal = CNLabeledValue(label: CNLabelHome, value: postal as CNPostalAddress)
        contact.postalAddresses = [homePostal]
        
        // 获取通讯录操作请求对象
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: nil)
        // 获取通讯录
        let store = CNContactStore()
        // 保存联系人
        // 通讯录有变化之后，还可以监听是否改变（CNContactStoreDidChangeNotification）
        do {
            try store.execute(request)
        } catch let error {
            print(error)
        }
        
    }
    func queryContact(name:String) -> [CNContact]? {
        let store = CNContactStore()
        //检索条件
        let predicate = CNContact.predicateForContacts(matchingName: name)
        let formatter = CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
        let des:[CNKeyDescriptor] = [formatter]
        do {
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: des)
            
            return contacts
        } catch {
           return nil
        }
    }
    
    //MARK: 展示联系统系人页面
    func showContacts(vc:UIViewController) {
        let store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status != .authorized { // 没有授权
            store.requestAccess(for: CNEntityType.contacts, completionHandler: { (isLgranted, error) in
                DispatchQueue.main.async {
                    if isLgranted == true { // 授权成功
                        self.presentContactPickerVC(vc: vc)
                    } else { // 授权失败
                        self.showAlertView()
                    }
                }
            })
        } else {
            self.presentContactPickerVC(vc: vc)
        }
    }
    
    fileprivate func presentContactPickerVC(vc:UIViewController) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate =  self
        contactPicker.modalPresentationStyle = .fullScreen
        vc.present(contactPicker, animated: true, completion: nil)
    }
    fileprivate func showAlertView() {
        //请在系统设置中开启通讯录服务
        let url = URL.init(string: UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url!, options: [:]) { (success) in }
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    //单选联系人
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        let lastName = contactProperty.contact.familyName
        let firstName = contactProperty.contact.givenName
        print("选中人的姓：\(lastName)")
        print("选中人的名：\(firstName)")
        if let phoneValue = contactProperty.value as? CNPhoneNumber {
            let phone = self.filterPhoneNum(phoneValue.stringValue)
            print("phone:\(phoneValue.stringValue)")
            print("phone:\(phone)")
            self.phoneBlock?(phone)
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.cancleBlock?()
    }
    fileprivate func filterPhoneNum(_ phone:String) -> String {
        var numString = phone
        if numString.contains("+86"){
            numString = numString.replacingOccurrences(of: "+86", with: "")
        }
        if numString.contains(" "){
            numString = numString.replacingOccurrences(of: " ", with: "")
        } else if numString.contains("-"){
            numString = numString.replacingOccurrences(of: "-", with: "")
        }
        return numString
    }
}
