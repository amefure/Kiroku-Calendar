//
//  EventController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/31.
//

import Foundation
import EventKit


class EventController {
    
    let eventStore: EKEventStore = EKEventStore()
    var events: [EKEvent]? = nil
    
    init(){
        authStatusRequest()
    }
    
    // MARK: - ユーザーの設定がONならイベントを読み込む
    func judgeUserSetting(){
        let userDefaults = UserDefaults.standard
        let calendarBool = userDefaults.string(forKey: "calendar") ?? "1"
        if calendarBool == "1"{
            self.loadEvents()
        }else{
            self.events = nil
        }
    }
    
    func authStatusRequest(){
        if EKEventStore.authorizationStatus(for: .event) == .notDetermined {
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if granted && error == nil {
//                    print("許可")
                    self.loadEvents()
                }
            })
        }
    }
    
    func loadEvents() {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: Calendar.current.date(byAdding: .month, value: -24, to: Date())!, end: Calendar.current.date(byAdding: .month, value: 24, to: Date())!, calendars: calendars)
        events = eventStore.events(matching: predicate)
    }
    
//    func newEvent(title: String) {
//        let event = EKEvent(eventStore: eventStore)
//        event.title = title
//        event.startDate = Date()
//        event.endDate = Date()
//        event.isAllDay = true
//        event.calendar = eventStore.defaultCalendarForNewEvents
//        try! eventStore.save(event, span: .thisEvent)
//        loadEvents()
//    }
//
//    func removeEvent(at indexPath: IndexPath) {
//        guard let events = events else { return }
//        let event = events[indexPath.row]
//        try! eventStore.remove(event, span: .thisEvent)
//        loadEvents()
//    }
}
