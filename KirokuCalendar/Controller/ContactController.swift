//
//  ContactController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/11/01.
//

import Foundation
import Contacts


class ContactController {
    

    let contactStore: CNContactStore = CNContactStore()
    var contacts: [CNContact]?
    
    let keys = [CNContactGivenNameKey as CNKeyDescriptor,CNContactBirthdayKey as CNKeyDescriptor,CNContactFamilyNameKey as CNKeyDescriptor]
//      CNContactFamilyNameKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor
    init(){
        authStatusContactRequest()
        self.loadContacts()
    }
    
    // MARK: - ユーザーの設定がONならイベントを読み込む
    func judgeUserSetting(){
        let userDefaults = UserDefaults.standard
        let contactBool = userDefaults.string(forKey: "contact") ?? "1"
        if contactBool == "1"{
            self.loadContacts()
        }else{
            self.contacts = nil
        }
    }
    
    
    // MARK: - Contacts
    func authStatusContactRequest(){
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined{
            contactStore.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                if granted && error == nil {
                    // 許可
                }else{
                    let userDefaults = UserDefaults.standard
                    userDefaults.set("0", forKey: "contact")
                }
            })
        }
    }
    // MARK: - Contacts
    
    
    func loadContacts() {
        
        let globalQ = DispatchQueue.global(qos: .background)
        globalQ.async {
            
            let request = CNContactFetchRequest(keysToFetch: self.keys)
            var contacts:[CNContact] = []
            do {
                try self.contactStore.enumerateContacts(with: request) {
                    contact, pointer in
                    contacts.append(contact)
                }
                
            }
            catch {
//                print("error")
//                print(error.localizedDescription)
            }
            self.contacts = contacts
        }
       
//        let mainQ = DispatchQueue.main
//        mainQ.async {
//
//        }

    }
}
