//
//  NotificationController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/11/01.
//

import UIKit

class NotificationController {
    
    init(){
        self.requestNotification()
    }
    
    // MARK: - ユーザーの設定がONならイベントを読み込む
    func judgeUserSetting() -> Bool{
        let userDefaults = UserDefaults.standard
        let calendarBool = userDefaults.string(forKey: "badge") ?? "1"
        if calendarBool == "1"{
            return true
        }else{
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = 0
            return false
        }
    }
    
    func requestNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
          // 許可を申請
            if granted && error == nil {
//                    print("許可")
            }else{
                let userDefaults = UserDefaults.standard
                userDefaults.set("0", forKey: "badge")
            }
        }
    }
    
    func setbadgeNumber(num:Int){
        if judgeUserSetting() {
            let application = UIApplication.shared
            application.applicationIconBadgeNumber = num
        }
    }
            
}
