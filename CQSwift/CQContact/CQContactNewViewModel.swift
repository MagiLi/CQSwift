//
//  CQContactNewViewModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/16.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CQContactNewViewModel: NSObject, CNContactViewControllerDelegate {
    var newContactSucc:((_ contact:CNContact)->())? // 新建联系人成功
    var newContactCancel:(()->())? //新建联系人取消
    
    var phone:String?
    var controller:UIViewController!
    
    convenience init(controller:UIViewController) {
        self.init()
        self.controller = controller
    }
    
    //MARK: 新建联系人
    func creatContact() {
        let mobileNumber = CNPhoneNumber(stringValue: self.phone ?? "")
        let labeledValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
        let contact = CNMutableContact()
        contact.phoneNumbers = [labeledValue]
        
        let contactVC = CNContactViewController(forNewContact: contact)
        contactVC.delegate = self
        let navVC = UINavigationController(rootViewController: contactVC)
        navVC.modalPresentationStyle = .fullScreen
        self.controller.present(navVC, animated: true, completion: nil)
//        // 第一次运行的时候，会获取通讯录的授权（对通讯录进行操作，有权限设置）
//        let contact = CNMutableContact()
//
//        // 1、添加姓名（姓＋名）
//        contact.givenName = "san";
//        contact.familyName = "wangg";
//
//        // 2、添加职位相关
//        contact.organizationName = "公司名称"
//        contact.departmentName = "开发部门"
//        contact.jobTitle = "工程师"
//
//        // 3、这一部分内容会显示在联系人名字的下面，phoneticFamilyName属性设置的话，会影响联系人列表界面的排序
//        //    contact.phoneticGivenName = @"GivenName";
//        //    contact.phoneticFamilyName = @"FamilyName";
//        //    contact.phoneticMiddleName = @"MiddleName";
//
//        // 4、备注
//        contact.note = "同事"
//        // 5、头像
//        contact.imageData = UIImage(named: "head_nor")?.pngData()
//        // 6、设置email
//        let email = CNLabeledValue(label: CNLabelEmailiCloud, value: "feifei@163.com" as NSString)
//        contact.emailAddresses = [email]
//        // 8、添加电话
//        let mobileNumber = CNPhoneNumber(stringValue: "18510002000")
//        let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,
//                                         value: mobileNumber)
//        contact.phoneNumbers = [mobileValue]
//
//        // 9、添加urlAddresses,
//        let addressValue = NSString(string: "[http://baidu.com](http://baidu.com)")
//        let address = CNLabeledValue(label: CNLabelURLAddressHomePage, value: addressValue)
//        contact.urlAddresses = [address]
//
//
//        // 10、添加邮政地址
//        let postal = CNMutablePostalAddress()
//        postal.city = "北京"
//        postal.country =  "中国"
//        let homePostal = CNLabeledValue(label: CNLabelHome, value: postal as CNPostalAddress)
//        contact.postalAddresses = [homePostal]
//
//        // 获取通讯录操作请求对象
//        let request = CNSaveRequest()
//        request.add(contact, toContainerWithIdentifier: nil)
//        // 获取通讯录
//        let store = CNContactStore()
//        // 保存联系人
//        // 通讯录有变化之后，还可以监听是否改变（CNContactStoreDidChangeNotification）
//        do {
//            try store.execute(request)
//        } catch let error {
//            print(error)
//        }
        
    }
//    func queryContact(name:String) -> [CNContact]? {
//        let store = CNContactStore()
//        //检索条件
//        let predicate = CNContact.predicateForContacts(matchingName: name)
//        let formatter = CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
//        let des:[CNKeyDescriptor] = [formatter]
//        do {
//            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: des)
//
//            return contacts
//        } catch {
//           return nil
//        }
//    }
    
    //MARK: CNContactViewControllerDelegate
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        print("key : \(property.key)")
        return true
    }
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if let newContact = contact {
            self.newContactSucc?(newContact)
        } else {
            self.newContactCancel?()
        }
//        let familyName = contact?.familyName ?? ""
//        let givenName = contact?.givenName ?? ""
//        print("didCompleteWith: \(familyName) - \(givenName)")
        viewController.dismiss(animated: true, completion: nil)
    }
    

}
