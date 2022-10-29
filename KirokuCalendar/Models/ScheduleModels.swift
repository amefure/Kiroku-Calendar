//
//  ScheduleModels.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/24.
//

import UIKit
import RealmSwift

class ScheduleModels: Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var title:String
    @Persisted var memo:String
//    @Persisted var startDate:String
//    @Persisted var endDate:String
    @Persisted var start:Date
    @Persisted var end:Date
    
    
    func betweenDate(start:String,end:String,date:Date)->Bool{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateStr = df.string(from: date)
        if start <= dateStr && end >= dateStr {
            return true
        }
            return false
    }
}
