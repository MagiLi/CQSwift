//
//  CQContactAddViewModel.swift
//  CQSwift
//
//  Created by llbt2019 on 2022/6/16.
//  Copyright © 2022 李超群. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CQContactAddViewModel: NSObject, CNContactPickerDelegate, CNContactViewControllerDelegate {

    var phone:String?
    var controller:UIViewController!
    var addSucc:((_ contact:CNContact)->())? // 添加到已有联系人成功
    var addCancel:(()->())? // 添加到已有联系人取消
    
    convenience init(controller:UIViewController) {
        self.init()
        self.controller = controller
    }
    
    //MARK: 添加到已有联系人
    func addToExistingContacts() {
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

    fileprivate func editExistingContact(contact:CNContact) {
        guard let mutContact = contact.mutableCopy() as? CNMutableContact else  { return }
        let mobileNumber = CNPhoneNumber(stringValue: self.phone ?? "")
        let labeledValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
        mutContact.phoneNumbers.append(labeledValue)
 
        let contactVC = CNContactViewController(forNewContact: mutContact as CNContact)
        contactVC.delegate = self
        let navVC = UINavigationController(rootViewController: contactVC)
        navVC.modalPresentationStyle = .fullScreen
        self.controller.present(navVC, animated: true, completion: nil)
    }
    
    //MARK: CNContactPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.editExistingContact(contact: contact)
        })
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.addCancel?()
    }
    
    //MARK: CNContactViewControllerDelegate
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        print("key : \(property.key)")
        return true
    }
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: { [weak self] in
            if let newContact = contact {
                self?.addSucc?(newContact)
            } else {
                self?.addCancel?()
            }
        })
    }
    
}
