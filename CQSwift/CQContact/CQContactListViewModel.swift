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

class CQContactListViewModel: NSObject, CNContactPickerDelegate {
    
    var phoneBlock:((_ phoneNum:String)->())?
    var cancleBlock:(()->())?
    var controller:UIViewController!
    
    convenience init(controller:UIViewController) {
        self.init()
        self.controller = controller
    }
    
    //MARK: 展示统系联系人页面
    func showContacts() {
        self.contactListPage()
    }
    
    func contactListPage() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .notDetermined {
            CQContactManager.requestContactAuth(authSuccess: {
                self.presentContactPickerVC()
            }, authFailed: {
                CQContactManager.openSystemSettings()
            })
        } else if status == .authorized {
            self.presentContactPickerVC()
        } else {
            CQContactManager.openSystemSettings()
        }
    }
    
    fileprivate func presentContactPickerVC() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate =  self
        contactPicker.modalPresentationStyle = .fullScreen
        //contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        self.controller.present(contactPicker, animated: true, completion: nil)
    } 
   
    //MARK: CNContactPickerDelegate 
    // 跟方法contactPicker(_ picker:, didSelect contact:)同时存在时，此方法不执行
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {

        let lastName = contactProperty.contact.familyName
        let firstName = contactProperty.contact.givenName
        print("选中人的姓：\(lastName)")
        print("选中人的名：\(firstName)")
        if let phoneValue = contactProperty.value as? CNPhoneNumber {
            let phone = CQContactManager.filterPhoneSpecialString(phoneValue.stringValue)
            print("phone:\(phoneValue.stringValue)")
            print("phone:\(phone)")
            self.phoneBlock?(phone)
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.cancleBlock?()
    }

}
